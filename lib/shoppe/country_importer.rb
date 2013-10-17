module Shoppe
  module CountryImporter
    def self.import
      
      eu_members = ['Austria', 'Belgium', 'Bulgaria', 'Croatia','Cyprus','Czech Republic','Denmark','Estonia','Finland','France','Germany','Greece','Hungary','Ireland','Italy','Latvia','Lithuania','Luxembourg','Malta','Netherlands','Poland','Portugal','Romania','Slovakia','Slovenia','Spain','Sweden','United Kingdom']
      countries = File.read(File.join(Shoppe.root, 'db', 'countries.txt')).gsub(/\r/, "\n").split("\n").map { |c| c.split(/\t/) }
      countries.each do |code2, code3, name, continent, tld, currency|
        country = Country.new(:name => name, :code2 => code2, :code3 => code3, :continent => continent, :tld => tld.gsub('.', ''), :currency => currency)
        country.eu_member = true if eu_members.map(&:upcase).include?(name.upcase)
        country.save
      end
      
    end
  end
end
