all: dac8532_test dac8532_test_1

dac8532_test: dac8532_test.c
	gcc dac8532_test.c -o dac8532_test -lbcm2835

dac8532_test_1: dac8532_test_1.c
	gcc -o dac8532_test_1 dac8532_test_1.c -lbcm2835

clean:
	rm dac8532_test dac8532_test_1 
