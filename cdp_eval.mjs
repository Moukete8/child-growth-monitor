const wsUrl = process.argv[2];
const expr = process.argv[3];

const ws = new WebSocket(wsUrl);
let id = 1;

ws.addEventListener('open', () => {
  ws.send(JSON.stringify({ id: id++, method: 'Runtime.evaluate', params: { expression: expr, returnByValue: true } }));
});

ws.addEventListener('message', (event) => {
  const msg = JSON.parse(event.data);
  console.log(JSON.stringify(msg, null, 2));
  process.exit(0);
});

ws.addEventListener('error', (e) => {
  console.error('ws error', e.message);
  process.exit(1);
});

setTimeout(() => {
  console.error('timeout');
  process.exit(1);
}, 10000);
