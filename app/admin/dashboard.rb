ActiveAdmin.register_page "Dashboard" do

  action_item :view_site do
    link_to "1. Authenticate Facebook", fb_authentication_index_path
  end

  action_item :view_site do
    link_to "2. Run shit", get_data_path
  end

  action_item :super_action, only: :show, if: proc{ true } do
    "Only display this to super admins on the show screen"
  end

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do

    # Here is an example of a simple dashboard with columns and panels.
    #

    columns do


      # column do
      #   panel "Info" do
      #     para "Welcome to ActiveAdmin."
      #
      #     link_to "View", fb_authentication_index_path
      #     button class: "blank_slate" do
      #       para "Click here to Authenticate"
      #     end
      #
      #
      #
      #   end
      # end
    end
  end # content

end
