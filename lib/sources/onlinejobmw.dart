import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:html/parser.dart' show parseFragment;

import 'package:katswiri/dio_request.dart';
import 'package:katswiri/models/models.dart';
import 'package:katswiri/sources/base_source.dart';
import 'package:katswiri/sources/source_countries.dart';

class OnlineJobMW extends Source {
  @override
  String get title => 'OnlineJobMW';

  @override
  String get host => 'onlinejobmw.com';

  @override
  Countries get country => Countries.malawi;

  Map<String, String> get _headers => {
        'Host': host,
        'User-Agent':
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:107.0) Gecko/20100101 Firefox/107.0',
        'X-Requested-With': 'XMLHttpRequest',
        'Origin': 'https://onlinejobmw.com',
        'Alt-Used': 'onlinejobmw.com',
        'Referer': 'https://onlinejobmw.com/vacancies-in-malawi/',
      };

  @override
  Future<Job> fetchJob(String url, {bool refresh = false}) async {
    final Job job;
    final dio = DioRequest.getInstance(refresh: refresh);
    final response = await dio.get<String>(
      url,
      options: Options(
        headers: _headers,
      ),
    );

    final $ = parseFragment(response.data);
    job = Job(
      logo: $.querySelector('.company_logo')?.attributes['src']?.trim() ?? '',
      position: $.querySelector('.page-title')?.text.trim() ?? '',
      companyName: $.querySelector('.job-company')?.text.trim() ?? '',
      location: $.querySelector('.location > a')?.text.trim() ?? '',
      type: $.querySelector('li.job-type')?.text.trim() ?? '',
      posted: $.querySelector('.date-posted')?.text.trim() ?? '',
      description: $
              .querySelector('.job_listing-description')
              ?.outerHtml
              .replaceAll(
                  '(adsbygoogle = window.adsbygoogle || []).push({});', '')
              .trim() ??
          '',
    );

    return job;
  }

  @override
  Future<List<Job>> fetchJobs(
      {int page = 1, Map<String, String>? filter, bool refresh = false}) async {
    final listingsUri = 'https://$host/jm-ajax/get_listings';
    final List<Job> jobs = [];

    final dio = DioRequest.getInstance(refresh: refresh);
    final response = await dio.post<String>(
      listingsUri,
      options: Options(headers: _headers),
      data: FormData.fromMap({
        'page': '$page',
        'per_page': '6',
        'orderby': 'featured',
        'order': 'DESC',
        'show_pagination': 'false',
        if (filter?['position'] != null) 'search_keywords': filter?['position'],
        if (filter?['location'] != null) 'search_location': filter?['location'],
      }),
    );

    final json = jsonDecode(response.data as String);
    final html = json['html'];
    final $ = parseFragment(html);

    $.querySelectorAll('li.job_listing').forEach((element) {
      final job = Job(
        logo:
            element.querySelector('.company_logo')?.attributes['src']?.trim() ??
                '',
        position: element.querySelector('.job_listing-title')?.text.trim() ??
            element.querySelector('.position > h3')?.text.trim() ??
            '',
        companyName: element
                .querySelector('.job_listing-company > strong')
                ?.text
                .trim() ??
            element.querySelector('.company > strong')?.text.trim() ??
            'Unknown',
        location:
            element.querySelector('.job_listing-location > a')?.text.trim() ??
                element.querySelector('.location')?.text.trim() ??
                '',
        type: element.querySelector('li.job-type')?.text.trim() ?? '',
        posted: element.querySelector('.job_listing-date')?.text.trim() ?? '',
        url: element.querySelector('a')?.attributes['href'] ?? '',
      );

      if (!job.location.contains(RegExp('Information|Parasites'))) {
        jobs.add(job);
      }
    });

    return jobs;
  }
}
