# ifrb

Interactive fiction (IF), for interactive Ruby (IRB). Play interactive fiction games from within the cozy familiarity of irb! Write stories that incorporate actual, executable Ruby code in the dialog!

## Installation

RubyGems is your friend:

    $ gem install ifrb

## Usage

Try it with one of the examples:

    $ ifrb basil

Or, if you want to do it from within IRB directly:

    $ irb
    irb> require 'ifrb'
    irb> ifrb "basil"

## Writing Your Own Adventures

Just create a new ruby file. You need at least one method, called `start`, which will be called when your adventure loads.

    def start
      # ...
    end

Define methods inside that method to add actions that are available for players. At the very least, you should add a method called `look`, which will be called when the room loads. The `look` method should describe the room:

    def start
      def look
        _format <<-DESC
          You see a big room. Not much else in here.
        DESC
      end

      # ...
    end

Other rooms are defined as top-level methods:

    def start
      #...
    end

    def monster
      def look
        _format "Yuck! A monster!"
      end
      # ...
    end

Transition to rooms using the `_load_room` method:

    def start
      def north
        _load_room :monster
      end
    end

    def monster
      # ...
    end

See the examples for more information about writing your own adventures. Good luck!

## License

Creative Commons Attribution 4.0 International License -- (c) Jamis Buck <jamis@jamisbuck.org>

<a rel="license" href="http://creativecommons.org/licenses/by/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by/4.0/88x31.png" /></a><br /><span xmlns:dct="http://purl.org/dc/terms/" property="dct:title">IFRB</span> by <a xmlns:cc="http://creativecommons.org/ns#" href="http://github.com/jamis/ifrb" property="cc:attributionName" rel="cc:attributionURL">Jamis Buck</a> is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by/4.0/">Creative Commons Attribution 4.0 International License</a>.<br />Based on a work at <a xmlns:dct="http://purl.org/dc/terms/" href="http://github.com/jamis/ifrb" rel="dct:source">http://github.com/jamis/ifrb</a>.
