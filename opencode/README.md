# OpenCode Configuration

## Overview
This directory contains the configuration files for the OpenCode environment. These files manage plugin integrations, model provider settings, specialized agent assignments, and proxy behavior for the Antigravity service.

## Configuration Files
- **opencode.json**: Defines active plugins and model provider specifications.
- **oh-my-opencode.json**: Configures individual agents and their associated language models.
- **antigravity.json**: Controls the behavior of the Antigravity proxy, including debug and session recovery settings.

## Plugins
The environment is configured with the following plugins:
- `oh-my-opencode`
- `opencode-antigravity-auth@1.2.6`
- `opencode-openai-codex-auth`

## Provider and Model Configuration

### Google (Antigravity Proxy)
The Google provider is configured to use the Antigravity proxy for various models, including high-context Gemini and Claude variants.

| Model | Name | Context Window | Output Limit |
|:---|:---|:---|:---|
| gemini-3-pro-high | Gemini 3 Pro High (Antigravity) | 1,048,576 | 65,535 |
| gemini-3-pro-medium | Gemini 3 Pro Medium (Antigravity) | 1,048,576 | 65,535 |
| gemini-3-pro-low | Gemini 3 Pro Low (Antigravity) | 1,048,576 | 65,535 |
| gemini-3-flash | Gemini 3 Flash (Antigravity) | 1,048,576 | 65,536 |
| gemini-3-flash-lite | Gemini 3 Flash Lite (Antigravity) | 1,048,576 | 65,536 |
| claude-sonnet-4-5 | Claude Sonnet 4.5 (Antigravity) | 200,000 | 64,000 |
| claude-sonnet-4-5-thinking-* | Claude Sonnet 4.5 Thinking variants | 200,000 | 64,000 |
| claude-opus-4-5-thinking-* | Claude Opus 4.5 Thinking variants | 200,000 | 64,000 |

### OpenAI (Codex)
The OpenAI provider utilizes the Codex API with the following models:
- `gpt-5.2`
- `o3`
- `o4-mini`
- `codex-1`

## Agent Assignments
Agents are specialized roles within OpenCode, each assigned to a specific model.

| Agent | Assigned Model |
|:---|:---|
| Sisyphus | google/claude-opus-4-5-thinking-high |
| oracle | google/claude-opus-4-5-thinking-high |
| librarian | google/claude-sonnet-4-5 |
| explore | google/gemini-3-flash |
| frontend-ui-ux-engineer | google/gemini-3-pro-high |
| document-writer | google/gemini-3-flash |
| multimodal-looker | google/gemini-3-flash |

## Antigravity Proxy Settings
Settings for the Antigravity proxy service are managed in `antigravity.json`.

| Setting | Value | Description |
|:---|:---|:---|
| `quiet_mode` | `false` | Disables quiet mode for more verbose output. |
| `debug` | `true` | Enables debug logging for troubleshooting. |
| `keep_thinking` | `false` | Disables persistent thinking mode. |
| `session_recovery` | `true` | Enables recovery of interrupted sessions. |
| `auto_resume` | `true` | Automatically resumes processing after interruptions. |
| `resume_text` | `"continue"` | The text used to signal a resumption. |

## Quick Reference
- **Update Agents**: Modify `oh-my-opencode.json` to change agent-to-model mappings.
- **Configure Providers**: Modify `opencode.json` to add or remove model providers or plugins.
- **Proxy Troubleshooting**: Enable `debug` in `antigravity.json` and check logs in the `antigravity-logs/` directory.
