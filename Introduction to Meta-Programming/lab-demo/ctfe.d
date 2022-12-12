module ctfe;

import std;

// Metaprogramare

bool isPrime(int n)
{
    if (n == 2)
        return true;
    if (n < 1 || (n & 1) == 0)
        return false;
    if (n > 3)
    {
        for (auto i = 3; i * i <= n; i += 2)
            if ((n % i) == 0)
                return false;
    }
    return true;
}

int bar(int a, int b)
{
	return a + b;
}

void foo()
{
	// int a = bar(2, 3);
	int a = 2 + 3;
}


bool retIfPrimeTemplate(int num)()
if (isPrime(num) && num != 2)
{
	return true;
}

bool retIfPrimeParam(T)(T num)
if (__traits(compiles, { num.foo(); }))
{
	num.foo();
	return true;
}

void main()
{
	// CTFE = Compile-time function evaluation
	// #define x 2
	immutable x = 2;
	enum a = 3;

	static assert(isPrime(x));
	static assert(!isPrime(20));

	pragma(msg, "compile-time");

	static if (isPrime(2))
		pragma(msg, "shows");

	static if (isPrime(4))
		pragma(msg, "doesn't show");
	else
		pragma(msg, "this shows");

	if (isPrime(15))
		pragma(msg, "doesn't show 2");

	// auto res = retIfPrimeParam("abc");
	// res = retIfPrimeParam(a);

	static assert(!__traits(compiles, retIfPrimeParam(a) ));

	auto res = retIfPrimeTemplate!17();
	// res = retIfPrimeTemplate!2();
	// res = retIfPrimeTemplate!10();

	res = retIfPrimeTemplate!a();
}
