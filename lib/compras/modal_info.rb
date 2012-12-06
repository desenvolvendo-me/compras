module Compras
  module ModalInfo
    protected

    def modal_info_html
      if modal_info
        template.link_to_modal_info(:href => modal_object,
                                    :data_disabled => modal_object.nil?)
      end
    end

    def modal_info
      options.fetch(:modal_info, false)
    end

    def modal_object
      object.send(model_name)
    end
  end
end
