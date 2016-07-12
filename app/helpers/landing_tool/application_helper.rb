module LandingTool
  module ApplicationHelper
    def enable_disable_switch(*entry)
      link_to entry.last.active? ? 'Disable' : 'Enable', url_for([entry.last.active? ? 'disable' : 'enable', *entry]), method: :put, data: { confirm: 'Are you sure?' }
    end
  end
end