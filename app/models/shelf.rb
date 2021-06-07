class Shelf < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :items
  has_and_belongs_to_many :spaces

#     def self.reset_sandbox
#       sandbox = Shelf.find(20)
#       # destroy all items on the shelf
#       sandbox.items.destroy_all
#       # create all items from scratch and add them to the shelf
#       book_1 = Item.create(url: 'https://www.goodreads.com/book/show/567610.How_to_Read_a_Book')
#       book_1.notes = "
# There are 3 levels of reading.

# 1. 👀 Inspectional Reading
# Systematic skimming provides sufficient knowledge to understand the key steps of the author's reasoning and help you determine if you want to go further with the book:
# 💡 Read the preface
# 💡 Study the table of contents
# 💡 Check the index
# 2. 🧠 Analytical Reading
# If you want to get a deeper understanding of the author's thesis:
# 💡 Classify the book according to kind and subject matter.
# 💡 Define the problem or problems the author is trying to solve.
# 💡 Enumerate its major parts in their order and relation, and outline these parts as you have outlined the whole.
# 3. 📚 Comparative Reading
# If you want to understand the broader subject beyond the author's thesis in a particular book, use comparative reading to synthesize knowledge from several books on the same subject.
# 💡 Find the books and passages that are most relevant.
# 💡 Each author uses different terms and concepts to frame their argument - translate those to frame the problem with your own words.
# 💡 For one give argument, different authors have different answers - the value is the discussion you have with these authors."
#     sandbox.items << book_1

#     book_2 = Item.create(url: 'https://www.goodreads.com/book/show/34507927-how-to-take-smart-notes')
#     book_2.notes = "
# Niklas Luhmann, was a German sociologist who published over 70 books and 400 academic articles.
# Luhmann credited his achievements to his Zettelkasten, which contained over 90,000 ideas that helped him develop topics by knitting together ideas into a cohesive whole - his books wrote themselves, idea by idea.
# The word Zettelkasten is German for “slip box”, which refers to a box containing many slips of paper. Each slip represents a single, atomic idea that makes sense by itself, and also in combination with other ideas (similar to how our brain works, but with a better memory).

# There are five different types of note-taking processes that build on each other.

# 1. 📚 Fleeting Notes
# 💡 Notes taken from the object itself.
# 2. ✍️ Literature notes
# If a concept from the fleeting notes stands out:
# 💡 Write it in your own words.
# 💡 Write it in such away that if you read it 10 years later it would make complete sense by itself.
# 💡 One idea per note. If you need to define a term for the idea/concept to make sense, create a term definition card and link to it from the concept note.
# 💡 Include the complete reference for the source you got the idea from.
# 💡 Include the relevant citation (lastName, year, pp.22).
# 3. 💥 Permanent notes
# 💡 Literature notes only have one connection, to the book they came from. While permanent notes can have many connections (to individual notes, as part of multiple topics etc).
# 💡 Permanent notes are written in the context of your own ideas and interests.
# 💡 Unlike literature notes, they must be connectable across multiple contexts. This is why it’s important to capture a single idea on each page.
# 💡 When you have a single idea, you can click it together with another idea, like a jigsaw piece with infinite sides. However, the moment you bind two or more ideas together (into one note), then you lose the ability to take them apart or insert new ideas between them.

# How to connect permanent notes to other permanent notes:
# -Connect notes with a bridge note
# -Connect notes with a topic index

# 1. 🗄 Index notes
# 💡 An index note represents a cluster of related permanent notes
# 💡 A really cool thing about index notes, is that you can end up writing an entire chapter or article just by linking related notes together.
# 2. ☁️ Keyword notes
# 💡Keyword notes are very similar to index notes in that they contain a list of links to relevant notes, except at a more general level than index notes. So, while an index note might represent a table of contents for a chapter or an outline for an article, a keyword note might represent a table of contents for a book or entry points to many different sub-topics within a broader area.

# To write your first Zettelkasten note, start with an article about something you’re interested in. This process will work for books too, but an article is easier to practice with.
# Take fleeting notes, then literature notes. Use the first literature note you write as your first permanent note. After that, write every new permanent note with an eye towards how it fits in with what you already have. If it doesn’t, just add it as a new, standalone note.
# When you first get started, you’ll probably find that your initial topic clusters form quite quickly. It’s going to take time for clusters to start forming between-topics instead of in-topics, but that’s the whole point of doing this. As long as you make an effort to connect your current note to relevant existing notes, those will form by themselves.
# Some notes are going to end up getting totally lost in your Zettelkasten, just like how we forget things naturally. That’s okay. The advantage with a Zettelkasten in this case is that you can actually scan through orphan (forgotten) notes to see if they spark reminders that you can turn into connections now and again."
#     sandbox.items << book_2

#     blog_1 = Item.create(url: 'https://fortelabs.co/blog/the-4-levels-of-personal-knowledge-management/')
#     blog_1.notes = "
# 🧠 There are 4 steps to personal knowledge management, known as CODE:

# 1. Capture: Saving valuable information from the internet and the world around you
# 💡 You may occasionally save notes from sources you consume, such as books or podcasts, but don’t do much with them.
# 2. Organize: Breaking that information into small chunks and preparing them for later use
# 💡 You have begun to capture not just factual information, but ideas and creative inspiration: lessons you’ve learned, ideas you’ve had, quotes that resonated, connections between ideas, metaphors and analogies, observations and personal reflections, etc. This includes both ideas from your own thoughts and from external sources. You are on your devices like everyone else, but you are not just consuming information. You are capturing the best of what you find in your own personal library of knowledge.
# 💡 At this level your notes begin to work as a thought partner, reminding you of things you’d completely forgotten and surfacing unexpected connections between ideas.
# 💡 The emphasis shifts from capturing more information, to putting to use the knowledge you already have. You regularly refine your knowledge management tools and perform small experiments to discover better ways of doing things. You have a clear picture of how information flows through your system and ends up as tangible deliverables in the world.
# 3. Distill: Extracting the pieces of knowledge most relevant to your current goals
# 💡 You become more discerning and selective about the information you consume, strongly preferring only the highest quality, most substantive sources that directly relate to the goals you are working toward.
# 💡 You often surprise yourself with new, creative ways of using your notes, or find that they push your thinking in new directions.
# 💡 The benefits of your system extend beyond your personal goals and begin to impact the people around you. You make your most valuable knowledge available to others in concrete form, such as through a website, blog, social media feed, podcast, or product. Which means you are constantly attracting new opportunities and collaborations as others encounter your work.
# 4. Express: Turning your knowledge into creative output that has an impact on others
# 💡 You use these artifacts to make powerfully persuasive arguments, to recruit people to your cause, and to build an unassailable reputation for innovation and leadership.
# 💡 Your system continuously evolves and improves over time using the ideas it encounters, seemingly on its own and reliably produce creative breakthroughs.
# 💡 Eventually you also master the flow of information happening inside you – your innermost thoughts, feelings, intuitions, and desires. You use your system to study your own inner workings like a scientist. Your notes track patterns in your thinking and learning over time, helping you understand your own evolution and direct it intentionally"
#     sandbox.items << blog_1

#     blog_2 = Item.create(url: 'https://fs.blog/2021/02/feynman-learning-technique/')
#     blog_2.notes = "
# The Feynman Technique helps you turn information into knowledge that you can easily retrieve from your mind.
# There are 4 steps to the Feynman Learning Technique.

# 1. 👶 Pretend to teach the concept to a 10 years old.
# 💡 Using complicated jargon is a way to mask our understanding.
# 💡 In order to explain a concept in simple language, you need to have a deeper level of understanding of the concept.
# 💡 Explaining a concept in simple language that a child can understand is a good test to know if you have this deeper level of understanding.
# 2. 📚 Identify gaps in your explanation. Go back to the source material to better understand it.
# 💡 Expressing an idea in simples terms helps you identify the boundaries of your understanding: every simple idea constitutes 'what you know', while all the rest is 'what you don't know yet'.
# 💡 Now that you know where you have gaps in your understanding, go back to the source material. Augment it with other sources. Look up definitions.
# 💡 Keep going until you can explain everything you need to in basic terms.
# 3. 💭 Organize and simplify.
# Now you have a set of hand-crafted notes containing a simple explanation:
# 💡 Organize them into a narrative that you can tell from beginning to end and read it out loud.
# 💡 If the explanation sounds confusing at anyszxzx point, go back to Step 2.
# 💡 Keep iterating until you have a story that you can tell to anyone who will listen.
# 4. 👥 Transmit.
# 💡 If you really want to be sure of your understanding, run it past someone (ideally someone who knows little of the subject).
# 💡 The ultimate test of your knowledge is your capacity to convey it to another.
# 💡 The questions you get and the feedback you receive are invaluable for further developing your understanding."
#     sandbox.items << blog_2

#     video_1 = Item.create(url: 'https://www.youtube.com/watch?v=ipRvjS7q1DI')
#     sandbox.items << video_1
#     video_2 = Item.create(url: 'https://www.youtube.com/watch?v=KmuP8gsgWb8')
#     sandbox.items << video_2

#     podcast_1 = Item.create(url: 'https://open.spotify.com/show/40O0Lbp5ockSt0qSogo6q1?si=m7LS1FhwThim-M85auOOIw')
#     sandbox.items << podcast_1
#     podcast_2 = Item.create(url: 'https://open.spotify.com/episode/6s2Z9SMryJGpZZde8Y0SDz?si=z2Ym4D8RSVeTPQUP3PlpfQ')
#     sandbox.items << podcast_2

#     tweet_1 = Item.create(url: 'https://twitter.com/vgr/status/1047925106423603200')
#     tweet_1.notes = "
# 🏞 1. The Hierarchy of information
# There is a hierarchy of information based on consumption time and idea complexity:  'small minds discuss people, average minds discuss events, great minds discuss ideas'.
# The stable consumption/production positions are along what I've labeled the turnpike (a term borrowed from economics). You can move up and down along the turnpike. Get off the turnpike and your bad returns will start to kill you.
# You do need a job in the giant social computer, and that involves consuming and acting on information at higher level than others.
# If you don't manage your information economy career, you will default to the lowest level job in the social computer: processing very low-latency information with small-minded cognition for small bets.
# The way to manage your attention is not to 'unplug' but to be sensitive to your mind quality and consciously target the zone, moving fluidly between small/great mind.
# You have to increase the weights slowly and perhaps train your attention to exhaustion a bit. If you're in small mind zone and can only consume/produce tweets, try an essay. See how far you get. Strength-train attention from 10s to 10min.

# 💆‍♂️ 2. Quickly identify the quality of the content you are currently consuming and adapt your consumption
# Note that this atrophying of attention and latency limits will happen REGARDLESS of whether evil designers are trying to hack your attention and keep you phase-locked into their preferred 10s latency information loop. Their designs are in fact the LOAD you're training against
# A real adept ought to have strength-trained attention so they can spend an hour either reading a tweetstream or a once-in-a-generation history-disrupting philosophy book. No hack designer should be able to lock them down in the 0.1-10 second range.
# So stop blaming the media platforms for your own wallowing in small-minded twitter gossip about people. Strength train to the point where you decide whether to be there or elsewhere.

# 🧠 3. Avoid basic traps
# There are THREE ways to fail at this.
# a) Thinking you can be Great Minded all the time. The first failure mode manifests as trying to consume only information at your target level. Like only reading Economist and journal papers and trying to produce in institutional modes. This will fail. You need some information diet input from ALL levels to work at ANY level.
# b) Trying to be Great Minded on low latency information diet (upper left red box)
# c) Trying to consume high-latency information diet without aspiring to more than small-minded thoughts. Reading every trending tweet and every bestselling big history book and everything in between, but ALL at the same low level (ie as people gossip or play-by-play event tracking). Unsustainable.
# It's not addictive FOMOing that kills you, but not being able to translate the information consumption choices you're making into winning bets.
# "
#     sandbox.items << tweet_1

#     tweet_2 = Item.create(url: 'https://twitter.com/Mappletons/status/1250532315459194880')
#     tweet_2.notes = "Most popular digital gardens"
#     sandbox.items << tweet_2
#     end
end
