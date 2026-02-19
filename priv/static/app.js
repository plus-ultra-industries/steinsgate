import React from 'https://esm.sh/react@18.3.1';
import { createRoot } from 'https://esm.sh/react-dom@18.3.1/client';

function App() {
  const [health, setHealth] = React.useState('checking...');

  React.useEffect(() => {
    fetch('/health').then(r => r.text()).then(setHealth).catch(() => setHealth('down'));
  }, []);

  return React.createElement('main', { style: { fontFamily: 'Inter, sans-serif', padding: 24 } }, [
    React.createElement('h1', { key: 'h1' }, 'Steins QA App'),
    React.createElement('p', { key: 'p1' }, `Health: ${health}`),
    React.createElement('p', { key: 'p2' }, 'Next: wire Inertia transport + project/run screens.')
  ]);
}

createRoot(document.getElementById('app')).render(React.createElement(App));
