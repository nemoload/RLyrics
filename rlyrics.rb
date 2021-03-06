load 'check.rb'
load 'fetch.rb'
load 'id3.rb'
load 'lyrics.rb'
load 'song.rb'

file = 1
search = 0
$BADLINE = "Usage of azlyrics.com content by any third-party lyrics provider is prohibited by our licensing agreement. Sorry about that."

def get_lyrics(query,my_song=nil)

	song = Fetch.AZLyrics(query)
	if my_song != nil
		song.title = my_song.title
		song.artist = my_song.artist
	end
	return song
end

def ask_to_save(song)
		p "Do you want to save the lyrics?[y,n]"
		ans = STDIN.gets
		if ans.chomp == "y"
			Lyrics.save(song,"lyrics.json")
		end
end

def print_lyrics(lyrics_arr)
	if lyrics_arr.class == Song
		lyrics_arr.lyrics.each{ |line| 
		if !line.match($BADLINE)
			print line.gsub("NEWLINE","\n")
		end
		}
    	else
		lyrics_arr.each {|line|
			#print line.gsub("NEWLINE","\n")	
			if line == $BADLINE
				#Do Nothing
			else
				print line.gsub("NEWLINE","\n")
		
			end
		}
	end
end


query = ARGV.join("+")

if Check.get_type(query) == 1
	song = ID3Tag.get(ARGV[0])
	lyrics = Lyrics.search(song,"lyrics.json")
	if lyrics.size == 0
		search_text = "#{song.artist}+#{song.title}"
		new_song = get_lyrics(search_text,song)
		print_lyrics(new_song)
                ask_to_save(new_song)
	else
		p song
		print_lyrics(lyrics)	
	end	
else
        #Requires internet connection, how dumb! 
        song = get_lyrics(query)
        lyrics = Lyrics.search(song,"lyrics.json")	
        if lyrics.size == 0
		print_lyrics(song)
		ask_to_save(song)
	else
		p song
		print_lyrics(lyrics)
			
	end	

end

