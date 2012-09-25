module Compras
  module ModalInfo
    protected

    def modal_info_html
      if modal_info
        template.link_to_modal_info(:href => object.send(:"#{model_name}"))
      end
    end

    def modal_info
      options.fetch(:modal_info, false)
    end
  end
end
