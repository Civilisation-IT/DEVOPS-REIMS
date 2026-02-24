import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  stages: [
    { duration: '30s', target: process.env.VUS_30 ? parseInt(process.env.VUS_30) : 150 },
    { duration: '1m30s', target: process.env.VUS_130 ? parseInt(process.env.VUS_130) : 350 },
    { duration: '20s', target: 0 },
  ],
};

export default function () {
  if (!process.env.TARGET_URL) {
    throw new Error('TARGET_URL environment variable is not set');
  }
  const res = http.get(process.env.TARGET_URL);
  check(res, { 'status was 200': (r) => r.status == 200 });
  sleep(1);
}