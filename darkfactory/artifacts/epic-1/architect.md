# Architect Output

```json
{
  "tasks": [
    {
      "id": "E1-T1",
      "title": "Implement core QA run pipeline",
      "depends_on": [],
      "parallelizable": false,
      "owner_role": "engineer",
      "acceptance": ["Run can be triggered manually", "Run result is persisted"]
    },
    {
      "id": "E1-T2",
      "title": "Capture screenshot evidence on failed checks",
      "depends_on": ["E1-T1"],
      "parallelizable": true,
      "owner_role": "engineer",
      "acceptance": ["Failure evidence includes screenshot path"]
    }
  ]
}
```
