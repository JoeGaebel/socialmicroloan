require 'loofah'

class SafeMarkdown < MdEmoji::Render
  def postprocess(document)
    Loofah.fragment(document).scrub!(:strip).to_s
  end
end
