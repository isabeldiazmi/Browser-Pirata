require "nokogiri"
require "open-uri"
require "net/http"
require "uri"

class Page
  def initialize(url)    
    @page = Net::HTTP.get(URI(url)) #NET te conecta a internet
    @doc = Nokogiri::HTML(@page) #NOKOGIRI es una libreria de metodos para buscar y moverte en la pagina
  end

  def fetch!
    puts "Fetching..."
    puts "Titulo: #{title}"
    puts "Links:"
    puts links
  end

  def links
    @doc.search("a").map { |link| link.inner_text + ": " + link['href'] }
  end

  def title
    @doc.search("html > head > title").inner_text
  end
end

class Browser
  def initialize(url)
    @url = url
  end

  def run!
    pagina = Page.new(@url)
    pagina.fetch!
    resp = false
    while resp == false
      puts "¿Quieres buscar otra pagina?"
      res = gets.chomp
      if res == "si"
        puts "Escribe la pagina:"
        nueva_url = gets.chomp
        pagina = Page.new(nueva_url)
        pagina.fetch!
      elsif res == "no"
        puts "FIN"
        resp = true
      else
        puts "No entendi la respuesta"
      end
    end
  end

end

brow = Browser.new('http://codea.mx')
brow.run!