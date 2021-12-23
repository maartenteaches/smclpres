//section Build your own class

//slide ------------------------------------------------------------------------
//title The goal

/*txt
{pstd}
We are going to write a program that receives a text file and returns a dataset
that contains a list of all words that occured in that file and how many times 
it appeared

{pstd}
We will write this using a class

{pstd}
The reason we do that, is that we think we want to extend this program (text 
analysis is a huge field)

{pstd}
We are writing this program with the goal that it should be easy to maintain and
extend
txt*/
//endslide ---------------------------------------------------------------------

//..............................................................................
//subsection Getting basic working code
//file cdu.txt
//file die_linke.txt
//file fdp.txt
//file gruene.txt
//file spd.txt


//slide ------------------------------------------------------------------------
//title Counting words
/*txt
{pstd}
Counting how often each word appears in a document is a classic application for 
an associative array

{pstd}
We can use {helpb mata fopen():fopen()} to open a file 

{pstd}
A basic start would be:
txt*/

//ex
mata:
mata clear
mata set matastrict on

hist = AssociativeArray()
hist.notfound(0)
fh = fopen("spd.txt", "r")

while ((line=fget(fh))!=J(0,0,"")) {
    line = tokens(line)
    for (i=1; i <= cols(line); i++) {
        freq = hist.get(line[i]) + 1
        hist.put(line[i], freq)
    }
}
fclose(fh)

hist.keys()[1..10,.]
hist.get("SPD")
end
//endex
//endslide ---------------------------------------------------------------------

//slide ------------------------------------------------------------------------
//title punctuation

/*txt
{pstd}
One problem is that punctiation marks are still attached to the words. So 
"Menschen." is counted as a different word as "Menschen"

{pstd}
We could make a string with all the punctuation marks we want to remove 
(separated by spaces)

{pstd}
use {helpb mf_tokens:tokens()} to turn that into a vector

{pstd}
use {helpb Mata subinstr()} to remove those (i.e. replace it with an empty string "")

//apcodefile hist01.do "(solution)"
txt*/
//endslide ---------------------------------------------------------------------

//slide ------------------------------------------------------------------------
//title Capital letters

/*txt 
{pstd}
The same word can appear starting with and without a capital letter, depending
on where it is in the sentence

{pstd}
These count now as different words

{pstd}
The easiest solution is to turn all capital letter into lower case letters with 
the {helpb mf_strupper:strlower()} function

//apcodefile hist02.do "(solution)"
txt*/
//endslide ---------------------------------------------------------------------

//slide ------------------------------------------------------------------------
//title Common "meaningless" words

/*txt
{pstd}
There are some words that are very common, but don't interest us

{pstd}
For example, "der", "die", und "das" 
txt*/

//ex
mata: hist.get("die")
//endex

//file stop_words_german.txt
/*txt
{pstd}
So we don't want to count those

{pstd}
The file "stop_words_german.txt" contains a list of these words

{pstd}
We can read that file into Mata using {helpb mata fopen():fopen()}

{pstd}
Put all words in an associative array called stopwords (with a value 1, which 
does not matter)

{pstd}
When we count the words from the main file, we first check if that words exists
in the array stopwords (stopwords.exists()) and only count if that is not the case

//apcodefile hist03.do "(solution)"
txt*/
//endslide ---------------------------------------------------------------------

//slide ------------------------------------------------------------------------
//title Finding the most common words

/*txt
{pstd}
So what are the most commonly used words in this document?

{pstd}
We can extract a vector of words using {cmd:hist.keys()}, which we will call words

{pstd}
We create a new numeric vector (count) with the same number of rows, loop over 
those and fill these cells with the corresponding counts

{pstd}
We use {helpb mata sort():order()} to create a permutation vector: The first 
cell in that vector contains the rownumber that cell should be for it to be 
ordered, etc. We will call that vector o

{pstd}
We can now order both words and count using {cmd:words = words[o]} and the same 
for count

{pstd}
Do this

//apcodefile hist04.do "(solution)"
txt*/

//endslide ---------------------------------------------------------------------


//slide ------------------------------------------------------------------------
//title Export the results to Stata

/*txt
{pstd} Then we create new variables with {cmd:st_addvar()} to add the variables

{pstd}
For string variables we need to know the maximum length (in bytes, not characters)
of the words we want to store. We can get that with the {cmd:strlen()} function
and {cmd:max()} function

{pstd}
For numeric variables we can use {cmd:st_store()} to store the vector in the 
variable

{pstd}
For string variables we can use {cmd:st_sstore()}

{pstd}
But first we need to make sure there are enough observations in the Stata dataset
to take all those words. We can count the number of observation with {cmd:st_nobs()}
and add any extra observations we may need with {cmd:st_addobs()}

//apcodefile hist05.do "(solution)"
txt*/
//endslide ---------------------------------------------------------------------

//..............................................................................
//subsection Turning it into a Mata class

//slide ------------------------------------------------------------------------
//title Getting started

/*txt
{pstd}
I usually start with defining the class and naming the variables and functions
I want it to contain

{pstd}
This gives me a roadmap of what I need to do

{pstd}
This is where I would start


{cmd}
    class hist_gen {
        string                  scalar    fn_stopwords
        class  AssociativeArray scalar    stopwords
        string                  scalar    fn
        class  AssociativeArray scalar    hist
        string                  rowvector punct
        
        void                              make_hist()       
        void                              setup()           
        void                              parse_stopwords() 
        void                              count_words()     
        string                  rowvector parse_line()      
        real                    scalar    valid_word()      
        void                              to_stata()        
    }


    void hist_gen::parse_stopwords() 
    {
        //line 7-16 of hist05.do
    }

    void hist_gen::setup() 
    {
        parse_stopwords()
        //line 22 of hist05.do  
    }

    void hist_gen::make_hist()
    {
        setup()
        count_words()
    }   

    void hist_gen::count_words()
    {
        // line 24-37 of hist05.do
        // but using parse_line() for lines 25-29
        // and use valid_word() for the condition on line 31
    }

    string rowvector hist_gen::parse_line(string scalar line)
    {
        // line 25-29 of hist05.do
    }

    real scalar hist_gen::valid_word(string scalar word)
    {
        // line 31 of hist05.do
    }

    void hist_gen::to_stata()
    {
        // line 39-57 of hist05.do
    }
    end

    //intended use
    mata:
    hist = hist_gen()
    hist.fn           = "spd.txt"
    hist.fn_stopwords = "stop_words_german.txt"
    hist.punct        = `", . ; : ! ? ( ) [ ] > < - – * "'
    hist.make_hist()
    hist.to_stata()
    end
{txt}

{pstd}
create a working version of this class

//apcodefile hist06.do "(solution)"
txt*/
//endslide ---------------------------------------------------------------------

//slide ------------------------------------------------------------------------
//title Passing parameters to our class

/*txt
{pstd}
For safety you normally would not want users to directly access variables

{pstd}
Instead you would want them to go through a function

{cmd}
    class hist_gen {
        string                  scalar    fn_stopwords
        class  AssociativeArray scalar    stopwords
        string                  scalar    fn
        class  AssociativeArray scalar    hist
        string                  rowvector punct
        
        transmorphic                      fn_stopwords()
        void                              make_hist()       
        void                              setup()           
        void                              parse_stopwords() 
        void                              count_words()     
        string                  rowvector parse_line()      
        real                    scalar    valid_word()      
        void                              to_stata()        
    }

    transmorphic hist_gen::fn_stopwords(| string scalar val)
    {
        if (args() == 1) {
            // here you can put checks if val is appropriate for that variable
            fn_stopwords = val
        }
        else {
            return(fn_stopwords)
        }
    }
{txt}

{pstd}
Make functions for {cmd:fn}, and {cmd:punct}

//apcodefile hist07.do "(solution)"
txt*/
//endslide ---------------------------------------------------------------------

//slide ------------------------------------------------------------------------    
//title private and public

/*txt
{pstd}
Right now user's can still access the variables and all functions.

{pstd}
We can prevent that by declaring them private

{pstd}
It is generally a good idea to make only the functions the user needs public

{cmd}
    class hist_gen {
        protected: 
            string                  scalar    fn_stopwords
            class  AssociativeArray scalar    stopwords
            string                  scalar    fn
            class  AssociativeArray scalar    hist
            string                  rowvector punct

            void                              setup()
            void                              parse_stopwords()
            string                  rowvector parse_line()
            real                    scalar    valid_word()
            void                              count_words() 

        public: 
            transmorphic                      fn_stopwords()
            transmorphic                      fn()
            transmorphic                      punct()
            void                              make_hist()
            void                              to_stata()
    }
{txt}
txt*/

//endslide ---------------------------------------------------------------------

//..............................................................................
//subsection What next
//slide ------------------------------------------------------------------------
//title Next steps

/*txt 
{pstd}
write Stata program to interface with that our class

{pstd}
Write certification scripts

{pstd}
Write the help-files
txt*/
//endslide ---------------------------------------------------------------------


********************************************************************************
//subsection Wrapping up
//slide ------------------------------------------------------------------------
//title Useful sources

/*txt
{pstd}
Very useful free websources for learning how to use Mata and program commands in 
Stata are:

{pmore}
Bill Gould's {browse "https://www.stata.com/meeting/uk10/UKSUG10.Gould.pdf" :Mata, the missing manual}
presented at the 2010 UK Stata Users' Group meeting.

{pmore}
David Drukker's Blog {browse "https://blog.stata.com/2016/01/15/programming-an-estimation-command-in-stata-a-map-to-posted-entries/" :Programming an estimation command in Stata} 

{pstd}
If you want to dive deep into Mata, then you cannot go wrong with 

{pmore}
William W. Gould (2018), {it:The Mata Book: A Book for Serious Programmers and Those Who Want to Be}.  
College Station, TX: The Stata Press.
txt*/
//endslide ---------------------------------------------------------------------
