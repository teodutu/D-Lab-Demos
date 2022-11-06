import std;

const int x;
int y;

int impureFunc()
{
	return y;
}

int pureFunc() pure
{
	return x;
}

int pureTemplateFunc(T)()
{
	return x;
}

void weaklyPureFunc(int[] arr) pure
{
    arr[0] = 10;
}

void main() pure
{
	// impureFunc();

    int cx = pureFunc();
    assert(cx == 0);
    
    cx = pureTemplateFunc!double();
    assert(cx == 0);

    int[] arr = [1, 2, 3];
    weaklyPureFunc(arr);
    assert(arr == [10, 2, 3]);
}
