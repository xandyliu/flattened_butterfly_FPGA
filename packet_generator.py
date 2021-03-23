import sys
import numpy as np
import random
import os
import math

def usage():
	print("Usage \n")
	print("python3 packet_generator.py <num_packets> <payload_length> <radix> <stages> <output_file_name> \n")
	print("output_file_name is optional will default to test.mem in the current working directory")


def packet_gen(num_packets,payload_length,radix,stages,output_file_name="test.mem"):
	num_packets=int(num_packets)
	payload_length=int(payload_length)
	header_size = math.log(radix**stages,2)
	format_str = str(payload_length)
	formater_payload = "{:0"+str(payload_length)+"d}"
	formater_header = "{:0"+str(int(header_size))+"d}"

	fout = open(output_file_name, 'w+')
	# print(formater)
	print(" ")
	for y in range(0,num_packets):
		for x in range(0, payload_length):
			if(x == 0):
				payload = random.randint(0,1)
			else:	
				payload = str(payload) + str(random.randint(0,1))
			payload = formater_payload.format(int(payload))
		print("payload data bits : "+ payload)

		print("Header size in bits : "+ str(header_size))
		for x in range(0, int(header_size)):
			if(x == 0):
				header = random.randint(0,1)
			else:	
				header = str(header) + str(random.randint(0,1))


		total_packet = formater_header.format(int(header)) + formater_payload.format(int(payload))
		fout.write(str(total_packet)+'\r')
		print("Header data bits : "+ str(header))
		print("Overall Packet is : "+ str(total_packet))
		print("-------------------------------------------------------")
	fout.close()

#Main Function
def main():
	if(len(sys.argv) < 5):
		usage()
		quit()
	elif(len(sys.argv) == 6):
		num_packets = int(sys.argv[1])
		payload_length = int(sys.argv[2])
		radix = int(sys.argv[3])
		stages = int(sys.argv[4])
		output_file_name = sys.argv[5]
		packet_gen(num_packets,payload_length,radix,stages,output_file_name)
	else:
		num_packets = int(sys.argv[1])
		payload_length = int(sys.argv[2])
		radix = int(sys.argv[3])
		stages = int(sys.argv[4])
		packet_gen(num_packets,payload_length,radix,stages)        


if __name__ == "__main__":
	main()