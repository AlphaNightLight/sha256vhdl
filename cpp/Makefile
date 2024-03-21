all : main.exe

clean :
	rm -rf main.exe

main.exe : main.cpp sha256.cpp
	g++ main.cpp sha256.cpp -std=c++11 -O3 -o main.exe
