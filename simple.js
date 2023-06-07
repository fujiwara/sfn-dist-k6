import http from 'k6/http'
import { check } from 'k6'
export default function () {
  let res = http.get('https://test.k6.io/news.php');
  check(res, { 'success': (r) => r.status === 200 });
}
export function handleSummary(data) {
  return {
    '/tmp/summary.json': JSON.stringify({
      'checks': data.metrics.checks.values,
      'http_reqs': data.metrics.http_reqs.values,
    })
  }
}
