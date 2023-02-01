require 'httparty'

# india
# dubai
# singapore
# europe

# rajasthan
# goa
# kerala himachal 
# ladakh north east
itenary = "Day 1: Arrive in Jaipur and check into your hotel. Visit the Hawa Mahal (Palace of Winds) and Jantar Mantar observatory in the afternoon.

Day 2: Full-day tour of Jaipur, visiting the Amber Fort, City Palace, and Jal Mahal.

Day 3: Visit the Elephant Village and enjoy a traditional elephant ride. Afterwards, head to the Jaigarh Fort.

Day 4: Drive to Udaipur and check into your hotel. Spend the rest of the day exploring the local markets and enjoying a leisurely stroll along the lake.

Day 5: Visit the City Palace and take a boat ride on Lake Pichola. In the evening, attend the Light and Sound Show at the City Palace.

Day 6: Visit the Jagdish Temple, Bhartiya Lok Kala Museum, and the Saheliyon-ki-Bari.

Day 7: Spend your last day in Udaipur visiting the Monsoon Palace and the Fateh Sagar Lake before departing for your next destination."



# puts itenary

def desti_attrac(words)
  places = []
  keywords = ["city", "town", "village", "place","Arrive","Visit","Drive","day",'vist','arrive','tour']
  words.each_with_index do |word, index|
    if keywords.include?(word)
      place = words[index + 2]
      next_word = words[index + 3]
      place += " #{next_word}" if next_word !~ /[^A-Za-z]/
      places << place
      
    end
  end

  puts "Place: #{places}"
end

def regscan(sentence)
  
  sentence = sentence.sub(/^\d+\:/, '').strip
  puts sentence
  places = []
  place_name = sentence.scan(/[A-Z][a-z]+/)
  places <<place_name
  places = places.flatten
  puts "Place: #{places}"
end

def day_split(itenary)
  days = itenary.split("Day")
   
  day_hash = {}

  days.each_with_index do |day,index|
    day_hash[index ] = day
  end
day_hash
end


def decapitalise(sentence)

  sentence = sentence.sub(/^\d+\:/, '').strip

  sentences = sentence.split(/[.!?]/)

  new_sentences = sentences.map do |sentence|
    words = sentence.split(" ")
    words[0] = words[0].downcase
    words.join(" ")
  end

  # puts "Modified Sentences: "
  # puts new_sentences.join(". ")
  new_sentences.join(". ")
end


def extractor(decapitalised_sentence)
  words = decapitalised_sentence.split(" ")
  capitalized_words = []
  combined_word = ""

  words.each do |word|
  if word[0].upcase == word[0]
  combined_word += word + " "
  else
  capitalized_words << combined_word.strip unless combined_word.empty?
  combined_word = ""
  end
  end

  capitalized_words << combined_word.strip unless combined_word.empty?

  # puts "Capitalized words: #{capitalized_words}"
  capitalized_words
end


def extract_places_and_attractions(words)
  # Your code to pre-process the sentence and split it into individual words

  # Initialize arrays to store the results
  places = []
  attractions = []
  unknown = []
  attraction_classes =['shop','historic','natural','tourism','leisure','building']
  words.each do |word|
    
    # Check if the word is a place name
    response = HTTParty.get("https://nominatim.openstreetmap.org/search?q=#{word}&format=json")
    if response.code == 200 && !response.empty?
      
      # puts "#{word} : #{response[0]['class']}"
      if response[0]['class'] == 'place'
        places << word
      elsif
        attraction_classes.include?(response[0]['class'])
        attractions<<word
      else
        unknown<<word
      end
    else
      # Check if the word is an attraction name
      # Your code to check if the word is an attraction name
      unknown << word
    end
  end
  puts "destinations:  #{places}" 
  puts  "attractions: #{attractions}"
  puts  "unknown: #{unknown}"
  return places, attractions,unknown
end



day_hash = day_split(itenary)


day_hash.each do |key,value|
	puts "#{key} : #{value}"
  # regscan(value.sub(/^\d+\:/, '').strip)
  # words = value.split(" ")
  # desti_attrac(words) 

  decapitalised_sentence = decapitalise(value.sub(/^\d+\:/, '').strip)
  places_attractions = extractor( decapitalised_sentence)
  # puts places_attractions
  # puts places_attractions.empty?() 
  extract_places_and_attractions(places_attractions)

end






















