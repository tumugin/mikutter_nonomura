# -*- coding: utf-8 -*-

require 'net/http'
require 'uri'
require 'nokogiri'

def ConvertNonomura(text)
    uri = URI.parse("http://www.brownmush.net/kengi")
    Net::HTTP.start(uri.host, uri.port){|http|
        request = Net::HTTP::Post.new(uri.path)
        request.set_form_data({:message=>text}, "&")
        response = http.request(request).body
        document = Nokogiri::HTML(response)
        nonomura = document.css("p.lead").inner_text
        return nonomura
    }
end

Plugin.create :mikutter_nonomura do
    command(:convert_nonomura,
        name: '野々村語変換',
        condition: lambda{ |opt| true },
        visible: true,
        role: :postbox
    ) do |opt|
        begin
            Plugin[:gtk].widgetof(opt.widget).widget_post.buffer.text = ConvertNonomura(Plugin[:gtk].widgetof(opt.widget).widget_post.buffer.text)
        end
    end
end