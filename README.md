# Word Suggestion

We tried to solve the problem of picking a good suggestion for a given word out of some suggestion candidates (dictionary of words) at [**Chicago Ruby Hack Night**](http://www.meetup.com/ChicagoRuby/events/116814862/). You can find the description of the problem [here](http://www.puzzlenode.com/puzzles/3-spelling-suggestions). Me and my friend [Ismael](https://twitter.com/ismaller) after some struggling and banging our head agains the wall came up with a solution which was kind of fun (Not sure if it's 100% correct!). We didn't get the time to code it that night so I thought I writ the code for it and share the solution here!

## Problem Definition

As you all know when you search for a word in a search engine and the word you searched for is not a correct word, they will offer you a suggestion!
For instance if you search for **Helloyi** you may get a suggestion in the following style:

_Did you mean **Hello**?_

Finding the appropriate suggestion is a famous problem in Computer Science algorithms called [**Edit Distance**](http://en.wikipedia.org/wiki/Edit_distance)! There are some well known algorithms for solving this problem! Probably one of the most famous ones is [Levenshtein](http://en.wikipedia.org/wiki/Levenshtein_distance)

The basic idea for these algorithms is how many steps needed to get to the suggestion candidate from the given word (in our example above from _Helloyi_ to _Hello_)! Obviously the candidate with the least number of steps would be a good suggestion!

There are some other (probably less accurate) ways to solve the same problem! For example, we can count **the longest commmon characters in the same order** between the given word and a collection of suggestion candidates:

```
Searched for: 
remimance

Suggestion candidates:
remembrance
reminiscence

Number of common characters in the same order for candidates respectively:
8
7

Then the better suggestion is:
remembrance

```

One way that we can solve this problem is using the location (indices) of characters in both given word and the suggestion candidate. The way it works is creating a data structure (kind of like a table) which for each letter in the given word, holds the possible positions for it in the suggestion candidate. Let's see how it looks for our example word above. The given word is **remimance** and the candidate is **remembrance**:

```
		|  r |    e   |  m | i|  m |a|n|c|    e   |
		___________________________________________
		
		|0, 6|1, 3, 10|2, 4|-1|2, 4|7|8|9|1, 3, 10|
		
=> -1 is for the time that the character in the given word doesn't exist in the suggestion candidate!
```

So this is the first step in solving this problem! We create this data structure based on the given word and the suggestion candidate. The next step is finding the **Longest Ascending Ordered Sequence of Numbers** in the possible positions we have. So We're gonna __Keep It Simple Stupid (KISS)__ here and just do a brute-force kind of solution to this.

We just start from each cell and collect an ascending ordered sequence of numbers until the last cell! (At each cell we pick the smalles number which is bigger than our last picked number) Then we compare the length of the created ascending sequences and pick the biggest number! So for the above example we have the following sequences:

```
[0, 1, 2, 4, 7, 8, 9, 10]
[1, 2, 4, 7, 8, 9, 10]
[2, 4, 7, 8, 0, 10]
[2, 7, 8, 9, 10]
[2, 7, 8, 9, 10]
[7, 8, 9, 10]
[8, 9, 10]
[9, 10]
[10]

In this case obviously the longest sequence is the first one with the length of 8!

** Note that it's not always the case that the first one is the longest (try to think of a sample word and candidate that prove this! :D)
```

So we do this process for all the suggestion candidates that we have and then the candidate with **Longest Ascending Sequence of Numbers** will be a good suggestion for the given word! In our above example if we repeat the process for the other suggestion candidate **reminiscence** as well, the longest ascending sequence of number of it will be **7**! So between these two candidates the first one **remembrance** is a better suggestion.

### Edge Cases
One edge case in this algorithm is when a character in the given word does not exist in the suggestion candiate! In that case conventionally we use **-1** for the possible position for that character which nicely suits our approach while we're creating the longest ascending sequence of numbers based on possible positions. The code that does this part is in ``search_suggester.rb`` file:

```ruby

def get_next_closest_position(positions, current_position)
  positions.sort!.each { |pos| return pos if pos > current_position }
  return current_position
end

```

As you see it fits our approach with no need to handle a special case for it cause we just pick the next number which is the smallest in the possible positions of current cell **AND** it's bigger than the what we've picked in the previous cell (``current_position``)!

### Further Work

IMHO this code **SUCKS!** :D and needs to be improved a lot! Some of the things that can be improved:
	* Definitely better names.
	* Less Primitive Obsession and nice objects in this domain.
	* etc.
	
There can be some edge cases that this algorithm is not supporting! We tested this for a lot of different inputs (given for the problem in [the problem definition](http://www.puzzlenode.com/puzzles/3-spelling-suggestions))! And some other weird words that came to my mind! But maybe there are still some cases that this algorithm does not support!

This is definitely not the efficient way to solve this problem! Because in a lot of cases we just do a brute force and some inner loop iterations which makes the code in some pieces O(n^2) and in some other pieces O(n^3)! And in a very long sequence of characters like DNAs, it can be horribly slow and inefficient! Performance was not a concern here but I just wanted to mention this weakness anyway!

### Related Readings

I definitely recommend reading about **Edit Distance** problem and some famous solutions for it. You can refer to the links mentioned at the beginning.

### Indexes and Locations are strong

Location based (index based) algorithms and solutions sometimes can be really interesting and powerful! For an interesting example of solving an old and famous problem such as sorting based on locations you can take a look at [**Counting Sort**](http://en.wikipedia.org/wiki/Counting_sort) which is a REALLY interesting algorithm with O(n) (depends though) which BTW is awesome for soritng problem!

### Testing

You can test this problem against your inputs in the following formats. Input file should contains the following information in the exact same lines and orders:

```
number of tests

first-given-word
first-dictionary-wrod
second-dictionary-word

second-given-word
first-dicitonary-word
second-dictionary-word

so on
…
…
```

Output file needs to be in the following format:

```
better-suggestion-for-first-input
better-suggestion-for-second-input
…

```

You can give these files as constructor arguments to ``SearchSuggesterVerifier`` class and call ``verify`` method on it!

**Feedbacks are welcome**