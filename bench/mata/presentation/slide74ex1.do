mata:
mata clear
mata set matastrict on

class threeD{
    private:
        pointer (real matrix) colvector data
        real                  scalar    rdim, cdim, zdim, setup
        void                            setup()
        void                            new()
        void                            isposint()
    
    public: 
        transmorphic                    rdim()
        transmorphic                    cdim()
        transmorphic                    zdim()
        void                            put()
        real matrix                     get()
}

void threeD::new()
{
    setup = 0
}

void threeD::isposint(real matrix tocheck)
{
    if (floor(tocheck)!= tocheck | any(tocheck :<= 0)) {
        _error(3300, "argument must be positive integers")
    }
}

transmorphic threeD::rdim(| real scalar val)
{
    if (args() == 1) {
        isposint(val)
        rdim = val
    }
    else {
        return(rdim)
    }
}
transmorphic threeD::cdim(| real scalar val)
{
    if (args() == 1) {
        isposint(val)
        cdim = val
    }
    else {
        return(cdim)
    }
}
transmorphic threeD::zdim(| real scalar val)
{
    if (args() == 1) {
        isposint(val)
        zdim = val
    }
    else {
        return(zdim)
    }
}
void threeD::setup()
{
    real scalar i
    
    if (setup) return
    if (rdim==. | cdim==. | zdim==.) {
        _error(30000, "rdim, cdim, and zdim need to be set first")
    }
    data = J(zdim,1,NULL)
    for(i=1; i<= zdim; i++) {
        data[i] = &J(rdim,cdim,.)
    }
    setup = 1
}
void threeD::put(real rowvector key, real matrix val)
{
    real scalar r, c, z
    real matrix toput
    
    if (!setup) setup()
    
    r = key[1]
    c = key[2]
    z = key[3]
    if ( z == . ) _error(3000, "z cannot be missing")

    toput = *data[z]
    toput[r,c] = val
    data[z] = &toput
}

real matrix threeD::get(real rowvector key)
{
    real scalar r, c, z
    real matrix toget
    
    if (!setup) return(J(0,0,.))
    
    r = key[1]
    c = key[2]
    z = key[3]
    if ( z == . ) _error(3000, "z cannot be missing")

    toget = *data[z]
    return(toget[r,c])
}

//intended use
data = threeD()
data.rdim(3)
data.cdim(2)
data.zdim(4)

A1 = 3,2 \
     3,1 \
     5,2

data.put((.,.,1), A1)
data.put((1,1,2), 2)
data.put((1,2,2), 7)

data.get((.,2,1))
data.get((1,1,2))
end
