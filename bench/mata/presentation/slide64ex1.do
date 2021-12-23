mata:
mata clear

void greetings(string scalar who)
{
    printf("Hello " + who)
}   

p = &greetings()

(*p)("BIBB")
end
