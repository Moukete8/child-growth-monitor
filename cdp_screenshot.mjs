import { writeFileSync } from 'fs';

const wsUrl = process.argv[2];
const outFile = process.argv[3];

const ws = new WebSocket(wsUrl);
let id = 1;

function send(method, params = {}) {
  const msgId = id++;
  ws.send(JSON.stringify({ id: msgId, method, params }));
  return msgId;
}

ws.addEventListener('open', () => {
  send('Page.enable');
  send('Page.captureScreenshot', { format: 'png' });
});

ws.addEventListener('message', (event) => {
  const msg = JSON.parse(event.data);
  console.error('msg', JSON.stringify(msg).slice(0, 300));
  if (msg.result && msg.result.data) {
    writeFileSync(outFile, Buffer.from(msg.result.data, 'base64'));
    console.log('saved');
    process.exit(0);
  }
});

ws.addEventListener('error', (e) => {
  console.error('ws error', e.message);
  process.exit(1);
});

setTimeout(() => {
  console.error('timeout');
  process.exit(1);
}, 10000);
