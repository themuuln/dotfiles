const hook = '/Users/ict/.config/tmux/plugins/tmux-pane-tree/scripts/features/hooks/hook-opencode.sh'

export const TmuxSidebarPlugin = async () => {
  return {
    event: async ({ event }) => {
      const eventType = String(event?.type ?? "")
      const status = String(
        event?.properties?.status?.type
        ?? event?.status
        ?? event?.state
        ?? ""
      )
      const message = String(
        event?.properties?.status?.message
        ?? event?.properties?.error?.message
        ?? event?.message
        ?? event?.summary
        ?? event?.transcript_summary
        ?? ""
      )

      if (!eventType && !status && !message) {
        return
      }

      const payload = JSON.stringify({
        event: eventType,
        status,
        message,
      })

      const proc = Bun.spawn(["bash", hook, payload], {
        env: {
          ...process.env,
        },
        stdin: "ignore",
        stdout: "ignore",
        stderr: "ignore",
      })

      await proc.exited
    },
  }
}
