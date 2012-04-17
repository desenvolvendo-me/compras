# encoding: utf-8
class MovimentTypePresenter < Presenter::Proxy
  attr_data 'operation' => :operation, 'character' => :character, 'id' => :id
end
