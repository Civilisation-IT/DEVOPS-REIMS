import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  stages: [
    { duration: '30s', target: __ENV.VUS_30 ? parseInt(__ENV.VUS_30, 10) : 150 },
    { duration: '1m30s', target: __ENV.VUS_130 ? parseInt(__ENV.VUS_130, 10) : 350 },
    { duration: '20s', target: 0 },
  ],
};

export default function () {
  if (!__ENV.TARGET_URL) {
    throw new Error('TARGET_URL environment variable is not set');
  }
  const res = http.get(__ENV.TARGET_URL);
  check(res, { 'status was 200': (r) => r.status == 200 });
  sleep(1);
}
