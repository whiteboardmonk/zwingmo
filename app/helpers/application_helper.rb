module ApplicationHelper
  def link_to_logo(size = "200x94")
    link_to image_tag("zwingmo.png", :size => size, :alt => '0', :class=> 'logo'), root_url
  end
  
end
