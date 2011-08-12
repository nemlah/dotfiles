#!/usr/bin/ruby -w

require 'rexml/document'
require 'pp'

class HtmlFormatter

  attr_reader :output
  attr_reader :original_input

  def htmlParse(input)

    input.gsub!(/<%(\s*if.*?)%>/,"\n<erblock><%\\1%>")
    input.gsub!(/<%(\s*while.*?)%>/,"\n<erblock><%\\1%>")
    input.gsub!(/<%(\s*remote_form_for.*?)%>/,"\n<erblock><%\\1%>")
    input.gsub!(/<%(\s*unless.*?)%>/,"\n<erblock><%\\1%>")
    input.gsub!(/<%(\s*else\s*)%>/,"\n</erblock>\n<erblock><% else %>")
    input.gsub!(/<%(\s*elsif\s*)%>/,"\n</erblock>\n<erblock><% elsif %>")
    input.gsub!(/<%(\s*end.*?)%>/,"\n</erblock>\n<% end %>")
    input.gsub!(/<%(\s*for\s.*?)%>/,"\n<erblock><%\\1%>")
    input.gsub!(/<%(\s*content_for.*?)%>/,"\n<erblock><%\\1%>")
    input.gsub!(/<%(\s*form_for.*?)%>/,"\n<erblock><%\\1%>")
    input.gsub!(/<%(\s*fields_for.*?)%>/,"\n<erblock><%\\1%>")

    #replace cdata tags with <cdata>, </cdata>
    input.sub!('//<![CDATA[', "<cdata>")
    input.sub!('//]]>', "</cdata>")

    #not get rid of the <%  %> marks
    input.gsub!(/<%/, "@@START_TAG@@")
    input.gsub!(/%>/, "@@END_TAG@@")

    #puts input

    level = 0
    previous_level =0
    line_count = 0
    active_script = false

    input.each_line{|l|

      this_line = l.gsub(/<\/?erblock>/, "")
      this_line = this_line.gsub(/\n/, "").strip

      if line_count != 0 && this_line.length > 0 && @output.length > 0
        @output += "\n"
      end

      line_count += 1
      s = l.scan(/<([^%][^\s>]*)(.*?)>/)
      #  puts l
      #  puts s.inspect
      #  puts "Level:#{level}"

      previous_level = level

      for match in s
        tag = match[0]
        attrs = match[1]

        # puts "#{line_count} -  Tag: #{tag} with attrs: #{attrs}"
        if tag == "script"
          active_script = true
        elsif tag == "/script"
          active_script = false
        end

        if tag =~ /^\//
          level -= 1
        elsif tag =~ /\/$/ || attrs =~ /\/$/ || tag =~ /^!--/
          #            puts "self closing and comments"
        elsif tag[0] != "%" and attrs =~ /%$/ #capture those cases where there is a less sign in an if expression
          #           puts "less signs"
        elsif
          level += 1
        end

      end

      if active_script
        if l.strip =~ /\{/
          level += 1
        elsif l.strip =~ /\}/
          level -= 1
        end
      end


      if this_line.length > 0
        if level  > previous_level
          #        @output += "#{''.ljust(previous_level, "\t")}#{this_line}{#{previous_level}}"
          @output += "#{''.ljust(previous_level, "\t")}#{this_line}"
        else
          #@output += "#{''.ljust(level, "\t")}#{this_line}{#{level}}"
          @output += "#{''.ljust(level, "\t")}#{this_line}"
        end
      end

      #  puts "Level:#{level}"
    }

    #replace CDATA again
    @output.sub!("<cdata>", "//<![CDATA[")
    @output.sub!("</cdata>",  "//]]>")
    @output.gsub!(/@@START_TAG@@/, "<%")
    @output.gsub!(/@@END_TAG@@/, "%>")


  end

  def outputDoc(doc)

    @level = 0;
    outputElement(nil, doc.root, @level)

  end

  def initialize(input)

    @output = ""
    htmlParse(input)

    #  puts @output
  end

  def self.ParseFile(path)

    #first open the file and store it in a string
    f = File.open(path)

    input = ""

    f.each_line {|l| input += l}

    HtmlFormatter.new(input)
  end

end

if ARGV.length > 0
  h = HtmlFormatter.ParseFile(ARGV[0])
  puts h.output
else
  h = HtmlFormatter.new(STDIN.read)
  STDOUT.write(h.output)
end
