import React from 'https://esm.sh/react@18.3.1';
import { createRoot } from 'https://esm.sh/react-dom@18.3.1/client';

function App() {
  const [projects, setProjects] = React.useState([]);
  const [name, setName] = React.useState('Demo Client');
  const [baseUrl, setBaseUrl] = React.useState('https://example.com');
  const [lastRun, setLastRun] = React.useState(null);

  async function refreshProjects() {
    const res = await fetch('/api/projects');
    setProjects(await res.json());
  }

  React.useEffect(() => {
    refreshProjects();
  }, []);

  async function createProject(e) {
    e.preventDefault();
    await fetch('/api/projects', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ name, base_url: baseUrl })
    });
    await refreshProjects();
  }

  async function runChecks(projectId) {
    const res = await fetch('/api/runs', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ project_id: projectId })
    });
    setLastRun(await res.json());
  }

  return React.createElement('main', { style: { fontFamily: 'Inter, sans-serif', padding: 24, maxWidth: 900 } }, [
    React.createElement('h1', { key: 'h1' }, 'Steins QA MVP'),
    React.createElement('p', { key: 'sub' }, 'Create project → run QA checks → export markdown report'),

    React.createElement('form', { key: 'form', onSubmit: createProject, style: { display: 'grid', gap: 8, marginBottom: 24 } }, [
      React.createElement('input', { key: 'n', value: name, onChange: e => setName(e.target.value), placeholder: 'Project name' }),
      React.createElement('input', { key: 'u', value: baseUrl, onChange: e => setBaseUrl(e.target.value), placeholder: 'Base URL' }),
      React.createElement('button', { key: 'b', type: 'submit' }, 'Add Project')
    ]),

    React.createElement('h2', { key: 'h2' }, 'Projects'),
    ...projects.map(p => React.createElement('div', { key: p.id, style: { border: '1px solid #ddd', padding: 12, marginBottom: 8 } }, [
      React.createElement('strong', { key: 'n' }, p.name),
      React.createElement('div', { key: 'u' }, p.base_url),
      React.createElement('button', { key: 'r', onClick: () => runChecks(p.id) }, 'Run QA')
    ])),

    lastRun && React.createElement('section', { key: 'run', style: { marginTop: 24 } }, [
      React.createElement('h2', { key: 'rh' }, `Last Run #${lastRun.run.id}`),
      React.createElement('a', { key: 'rep', href: `/api/reports/${lastRun.run.id}.md`, target: '_blank' }, 'Open Markdown Report'),
      ...lastRun.findings.map((f, i) => React.createElement('div', { key: i, style: { marginTop: 8 } }, `${f.status.toUpperCase()} | ${f.severity.toUpperCase()} | ${f.title}`))
    ])
  ]);
}

createRoot(document.getElementById('app')).render(React.createElement(App));
