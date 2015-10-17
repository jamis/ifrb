WORDS = %w(wonky insipid squeak babushka cantilever intrepid flipper
  periwinkle ewok munch gorgonzola ogle)

def start
  _format <<-DESC
    "Confound that blasted..."

    The dust swirles and settles to the gentle swearing of your master, Basil Smockwhitener (wizard and gentleman). Coughing, you push your way through to him, and find him trapped beneath a large fallen beam.

    Try as you might, thought, it's too much for you to lift. Basil appears to be injured, but he shoos you away.

    "Stop, Fabian," he says. "Just--stop. It's too heavy. Go on ahead and find the Magic Doohickie. We can use it to get this beam off me. It's the only way, now. No arguing! Just go!"

    You shrug, recognizing that tone of voice, and resigned as usual. "Yes, sir. I'll see what I can find."

  DESC

  armor = Class.new { def ticklish?; false; end }

  doohickie = Class.new do
    attr_reader :magic_a, :magic_b, :magic_c

    def initialize(a, b, c)
      @magic_a = a
      @magic_b = b
      @magic_c = c
    end

    def ==(h)
      magic_a == h.magic_a &&
        magic_b == h.magic_b &&
        magic_c == h.magic_c
    end

    def dup
      puts "Yeah, you kinda wish it were that easy, eh?"
      nil
    end

    alias clone dup
  end

  @__basil_freed = false
  @__locked = true
  @__armor = armor.new
  @__armory_blocked = true
  @__looted = false
  @__doohickie = doohickie.new(rand(100), rand(100), rand(100))
  @__setting_goal = rand(100)+1

  undef start
  basil
end

def basil
  def look
    if @__basil_freed
      _format <<-DESC
        Basil is free! You've done it! He's limping a bit, but he insists that it's nothing that a few cookies and a good night's rest won't cure. He gestures anxious to the south. "Let's go, Fabian!"
      DESC
    elsif @__looted
      _format <<-DESC
        You show Basil the Magic Doohickie and he breathes a sigh of relief. "You've done it, Fabian! Jolly good, old man! Now, just [adjust] the thing to the correct setting and get this beam off me. What? How should I know what the correct setting is? Just experiment. It's something between 1 and 100."
      DESC
    else
      _format <<-DESC
        What was formerly the ceiling now lies mostly on the floor, much of it unfortunately on your master, Basil. He gestures angrily at you to get moving. "Find the Doohickie!"

        The passage goes south (to the exit), and north (towards the treasure chamber). Presumably, Basil wants you to go north.
      DESC
    end
  end

  def adjust(setting=0)
    if !@__basil_freed && @__looted
      if setting < @__setting_goal
        _format "The doohickie grows cooler momentarily."
      elsif setting > @__setting_goal
        _format "The doohickie grows warmer momentarily."
      else
        @__basil_freed = true
        _format <<-DESC
          With a satisfying *thunk*, the beam that had trapped Basil disappears! He stands up, dusts himself off, and shakes your hand a bit more vigorously than you think the situation calls for. "Well done, man! You did it! Now, let's get out of here. To the south!"
        DESC
      end
    else
      _format "Adjust what? You're funny."
    end
  end

  def south
    if @__basil_freed
      _load_room :escape
    else
      _format <<-DESC
        Basil shouts angrily at you. "Not that way, you oaf! North! North! Get the Doohickie!" His mustaches are practically bristling.
      DESC
    end
  end

  def north
    if @__basil_freed
      _format <<-DESC
        "What are you, a glutton for punishment?" Basil shakes his head in disbelief. "Come along, Fabian. South, man! Let's get out of here."
      DESC
    else
      _load_room :lock
    end
  end
end

def lock
  def look
    if @__locked
      _format <<-DESC
        Not that you have much experience with looting abandoned treasure chambers or anything, but the pattern on the far wall looks a lot like a magical lock. Your hunch is borne out by a large sign above it that reads:

        "This is a magical lock. You'll never figure it out. Only a real magician, one able to [invoke] a spell that takes a string and reverses it, will ever manage to unlock it."

        Better get busy. The alternative is to go south again and tell Basil you failed. (Whew. That gives you chills just thinking about it.)
      DESC
    else
      _format <<-DESC
        There is a passage going north. This is because you successfully invoked the spell that unlocked it. Good for you! Basil would be so proud. Assuming he noticed.

        Oh, speaking of that. You can also go south, back to Basil.
      DESC
    end
  end

  def south
    _load_room :basil
  end

  def north
    if @__locked
      _format <<-DESC
        What, through a magically locked door? You might try opening it first. Although, you'll need to unlock it before you can open it. Have you tried [invoke] yet?
      DESC
    else
      _load_room :armory
    end
  end

  def invoke(spell=nil, &block)
    if spell.nil? && !block
      _format <<-DESC
        Nothing happens, and it does so in a surprisingly uninspiring way. (Maybe you should provide the spell you want to cast? Perhaps as a lambda, or a block? But I'm just the narrator. What would I know about magic?)
      DESC
    elsif spell && !spell.respond_to?(:call)
      _format "Um. I'm no expert, mind, but that doesn't look like a spell."
    else
      spell ||= block
      words = WORDS.shuffle[0,5]

      _format "Right. Let's see if this cantrip works. I'll just plug in a few words here..."
      success = words.all? do |word|
          result = spell[word]
          puts "    - `#{word}' becomes `#{result}'..."
          word.reverse == result
        end

      if success
        @__locked = false
        _format "What the..?! You did it! A passage opens to the north!"
      else
        _format "Hmm. That's not quite right. Maybe you should have another go?"
      end
    end
  end
end

def armory
  def look
    if @__armory_blocked
      _format <<-DESC
        The walls of this room are covered with exotic (and ancient-looking) weapons. Suits of armor are arranged haphazardly on stands, with one particularly imposing specimen standing--eerily life-like--right in front a door to the north. On its tabard is written the words:

        "Tickle me. I dare you."

        The only other exit is to the south.
      DESC
    else
      _format <<-DESC
        Aside from all the weapons and armor arranged around the walls, a large suit of armor lies prone on the floor.

        One passage lies open to the north, and another to the south.
      DESC
    end
  end

  def south
    _load_room :lock
  end

  def north
    if @__armory_blocked
      _format <<-DESC
        You think so, do you? Even with that big suit of armor daring you to tickle it?
      DESC
    else
      _load_room :treasury
    end
  end

  def tickle(what=:armor)
    if what == :armor
      if @__armor.ticklish?
        @__armory_blocked = false

        def tickle(what=:armor)
          _format "No need for more tickling. The armor is defunct!"
        end

        _format <<-DESC
          You boldly start scratching the suit along its sides, viciously making baby noises while watching the suit's arms. Hollowly, from deep within the armor, a tinny-sounding giggling begins. It grows in volume like the Doppler effect with poor AM reception until the suit's arms start flailing helplessly and the armor falls to the floor.

          As you back away, the giggling slowly fades, leaving nothing but rather unsettling echoes.

          The passage to the north is unblocked!
        DESC
      else
        _format <<-DESC
          You reach out hesitantly and poke the suit of armor about where its belly button ought to be. Feeling faintly ridiculous, you add, "goochie goochie goo."

          One of the suit's arms suddenly holds up a sign that reads, "Sorry. #ticklish? == false," before the other blindsides you and knocks you to the floor. By the time you stand up again, the armor has reset.

          Hmm. Maybe you ought to try to [enhance] the armor with a module that makes it [ticklish?]
        DESC
      end
    else
      _format "That's a rather odd thing to tickle."
    end
  end

  def enhance(mod)
    if @__armory_blocked
      @__armor.extend(mod)
      _format "Your enhancement settles experimentally onto the armor. Maybe try tickling it now?"
    else
      _format "The armor is nonfunctional, now. Enhancing it won't do anything."
    end
  end
end

def treasury
  def look
    if @__looted
      _format <<-DESC
        The fake Magic Doohickie looks pretty convincing there on its pedestal. Perhaps you should go rescue Basil now that yo uhave the real one. Go south!
      DESC
    else
      _format <<-DESC
        This is it! The treasury, containing the ancient and mysterious Magic Doohickie of Hank Doolickie! Its rumored powers are many, and its rumored guardians are...well...many, also. Somehow, you need to [swap] it with an identical [doohickie], so that the guards won't realize it's been taken.

        Or, you can give up and go south. Quitter.
      DESC
    end
  end

  def doohickie
    @__doohickie
  end

  def south
    _load_room :armory
  end

  def swap(a, b)
    if @__looted
      _format "Wait, don't do that! You've already pulled off the heist!"
    elsif a.equal?(b)
      _format "What are you trying to pull? You can't swap a thing with itself!"
    else
      a, b = b, a if b == @__doohickie
      if a == @__doohickie
        if a == b
          @__looted = true
          @__my_doohickie, @__doohickie = a, b
          _format <<-DESC
            Whoa! That was tricky! You totally swapped your fake for the real deal! This means...wait. This means you can go free Basil, now! Quickly, head south!
          DESC
        else
          _format <<-DESC
            Hmm...those don't quite look equivalent. I suspect something really, really, really, really, really, really, really bad would happen if you actually tried swapping them. Can you make your fake one look anything more like the real [doohickie]?
          DESC
        end
      else
        _format "That's...odd. Try that again, this time with the [doohickie]."
      end
    end
  end
end

def escape
  def look
    _format <<-DESC
      You've done it! You recovered the Magic Doohickie, rescued Basil, and capped it all of with a daring escape. Well, maybe not *daring*. But an escape, nonetheless.

      Well done!
    DESC

    quit
  end
end
