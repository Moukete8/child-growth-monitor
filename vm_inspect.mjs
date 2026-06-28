const wsUrl = process.argv[2];
const ws = new WebSocket(wsUrl);
let id = 1;

function send(method, params = {}) {
  const msgId = id++;
  ws.send(JSON.stringify({ jsonrpc: '2.0', id: msgId, method, params }));
  return msgId;
}

ws.addEventListener('open', () => {
  send('getVM');
});

ws.addEventListener('message', async (event) => {
  const msg = JSON.parse(event.data);
  if (msg.result && msg.result.isolates) {
    const isolateId = msg.result.isolates[0].id;
    send('ext.flutter.inspector.getRootWidgetSummaryTree', { isolateId, groupName: 'inspect' });
    return;
  }
  console.log(JSON.stringify(msg, null, 2).slice(0, 8000));
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
