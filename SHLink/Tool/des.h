/////////////////////////////////////////////////////////////// 
//	�� �� �� : des.h 
//	�ļ����� : DES/3DES����/���� 
//	��    �� : ��˫ȫ 
//	����ʱ�� : 2006��9��2�� 
//	��Ŀ���� : DES�����㷨 
//	��    ע : 
//	��ʷ��¼ :  
/////////////////////////////////////////////////////////////// 
 
#ifndef _DES_H_ 
#define _DES_H_ 
 
#include "general.h"
 
//Ϊ����߳���Ч�ʣ���������λ�������ܶ����ںꡣ 
 
//��ȡ��������ָ��λ. 
#define GET_BIT(p_array, bit_index)  	((p_array[(bit_index) >> 3] >> (7 - ((bit_index) & 0x07))) & 0x01) 
 
//���û�������ָ��λ. 
void SET_BIT(uint8 *p_array, uint8 bit_index, uint8 bit_val); 		
 
//�ӽ��ܱ�ʶ����������ʶ�漰���Ա��Ķ�ȡλ��, 
//���뱣֤DES_ENCRYPT = 0 DES_DECRYPT = 1 
typedef enum 
{ 
	DES_ENCRYPT = 0, 
	DES_DECRYPT = 1 
}DES_MODE; 
 
/////////////////////////////////////////////////////////////// 
//	�� �� �� : des 
//	�������� : DES�ӽ��� 
//	�������� : ���ݱ�׼��DES�����㷨�������64λ��Կ��64λ���Ľ��м�/���� 
//				������/���ܽ���洢��p_output�� 
//	ʱ    �� : 2006��9��2�� 
//	�� �� ֵ :  
//	����˵�� :	const char * p_data		����, ����ʱ��������, ����ʱ��������, 64λ(8�ֽ�) 
//				const char * p_key		����, ��Կ, 64λ(8�ֽ�) 
//				char * p_output			���, ����ʱ�������, ����ʱ��������, 64λ(8�ֽ�) 
//				uint8 mode				0 ����  1 ���� 
/////////////////////////////////////////////////////////////// 
void des(const char * p_data, const char * p_key, const char * p_output, DES_MODE mode); 
 
#endif //#ifndef _DES_H_



