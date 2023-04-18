* Written by R;
*  write.foreign(df = comb_2, datafile = "C:/Users/panyue/Box/WHIMS Data (From Alejandro, added 2.16.22)/WHIMS merge/comb_2_sas.csv",  ;

DATA  rdata ;
LENGTH
 record_id $ 11
 redcap_event_name $ 23
 interviewer_name $ 25
 dem3 $ 17
 dem4 $ 2
 medgyn8 $ 8
 medgyn10 $ 2
 medgyn15 $ 2
 risk1 $ 2
 risk2 $ 3
 risk6 $ 3
 risk7 $ 3
 risk11_specify $ 22
 risk13_specify $ 7
 risk18 $ 2
 vp3_specify $ 49
 vp14 $ 14
 vp38 $ 11
 vp53_specify $ 38
 phys1_abnormalities $ 137
 phys3_abnormalities $ 45
 phys4_abnormalities $ 119
 phys6_specify $ 62
 phys7_specify $ 62
 phys10_abnormalities $ 85
 phys15_specify $ 29
 phys_comments $ 184
 phys_examiner $ 42
 rapidtest_lab_specify $ 55
 pregnancy_lab_specify $ 55
 psa_lab_specify $ 85
 estrogen_lab $ 5
 discharge_lab_specify $ 55
 clue_cell_lab_specify $ 85
 whiff_lab_specify $ 85
 ph_lab_specify $ 85
 yeast_lab_specify $ 85
 chlamydia_lab_specify $ 85
 gonorrhea_lab_specify $ 85
 trichomonas_lab_specify $ 55
 medgyn30_specify_v2 $ 74
 risk4_v2 $ 3
 risk6_v2 $ 2
 risk13_specify_v2 $ 9
 vp3_specify_v2 $ 74
 interviewer_name_v2 $ 22
 medgyn8_v3 $ 5
 medgyn29_v3_specify $ 96
 risk13_specify_v3 $ 14
 vp3_specify_v3 $ 10
 vp14_v3 $ 14
 vp53_specify_v3 $ 12
 covid_1 $ 2
 covid_7 $ 5
 covid_8 $ 10
 covid_9 $ 5
 covid_10 $ 14
 covid_13 $ 45
 covid_15 $ 15
 covid_17 $ 100
 covid_85 $ 18
 covid_112 $ 86
 covid_117 $ 38
 covid_123 $ 10
 covid_126 $ 1
 covid_132 $ 24
 covid_135 $ 13
 covid_138 $ 9
 covid_141 $ 12
 covid_147 $ 17
 covid_150 $ 28
 covid_152 $ 60
 covid_154 $ 17
 covid_189 $ 45
 covid_200 $ 17
 covid_203 $ 12
 covid_217 $ 10
 from $ 2
 screen30 $ 34
 screen33 $ 14
 screen34 $ 36
 screen36 $ 47
 screen37 $ 54
 lab_nugent_no $ 85
 covid_13_6mo $ 11
 covid_17_6mo $ 18
 covid_112_6mo $ 70
 covid_117_6mo $ 8
 covid_132_6mo $ 22
 covid_150_6mo $ 6
 covid_152_6mo $ 15
 covid_189_6mo $ 36
 covid_190_6mo $ 20
 covid_191_6mo $ 53
 covid_217_6mo $ 26
;

INFORMAT
 date_today
 medgyn1
 medgyn3_b
 medgyn6
 medgyn11
 medgyn24
 risk3
 vp2
 vp11
 vp16
 vp20
 vp24
 vp31
 vp35
 vp40
 vp44
 last_mentral_period
 phys_date
 medgyn3_b_v2
 medgyn6_v2
 risk3_v2
 vp2_v2
 vp11_v2
 vp16_v2
 vp20_v2
 vp24_v2
 vp31_v2
 vp40_v2
 date_today_v2
 medgyn1_v3
 medgyn3_b_v3
 medgyn6_v3
 risk3_v3
 vp2_v3
 vp11_v3
 vp16_v3
 vp20_v3
 vp24_v3
 vp31_v3
 vp40_v3
 screen32
 screen35
 covid_18_6mo
 covid_26_6mo
 covid_27_6mo
 covid_30_6mo
 covid_31_6mo
 covid_34_6mo
 covid_35_6mo
 covid_42_6mo
 covid_43_6mo
 covid_46_6mo
 covid_47_6mo
 covid_50_6mo
 covid_51_6mo
 covid_54_6mo
 covid_55_6mo
 covid_62_6mo
 covid_63_6mo
 covid_66_6mo
 covid_67_6mo
 covid_70_6mo
 covid_71_6mo
 covid_74_6mo
 covid_75_6mo
 covid_188_6mo
 YYMMDD10.
;

INFILE  "C:/Users/panyue/Box/WHIMS Data (From Alejandro, added 2.16.22)/WHIMS merge/comb_2_sas.csv" 
     DSD 
     LRECL= 2348 ;
INPUT
 record_id
 redcap_event_name
 interviewer_name
 referral
 date_today
 dem1
 dem2
 dem3
 dem4
 dem5
 dem6
 dem7
 dem8
 dem9
 dem10
 dem11
 sociodemographics_complete
 medgyn0
 medgyn1
 medgyn3
 medgyn3_a
 medgyn3_b
 medgyn2
 medgyn4
 medgyn5
 medgyn6
 medgyn7
 medgyn8
 medgyn9
 medgyn10
 medgyn11
 medgyn12
 medgyn13
 medgyn14
 medgyn15
 medgyn16
 medgyn17
 medgyn18
 medgyn19
 medgyn20
 medgyn21
 medgyn22
 medgyn23___1
 medgyn23___2
 medgyn23___3
 medgyn23___4
 medgyn23___5
 medgyn23___6
 medgyn23___7
 medgyn23___8
 medgyn23___9
 medgyn23___10
 medgyn23_a
 medgyn24
 bv_datediff
 medgyn25
 medgyn26
 medgyn27
 medical_history_complete
 risk1
 risk2
 risk3
 risk4
 risk5
 risk6
 risk7
 risk8
 risk9
 risk10
 risk11
 risk11_specify
 risk13
 risk13_a___1
 risk13_a___2
 risk13_a___3
 risk13_a___4
 risk13_a___5
 risk13_a___6
 risk13_a___7
 risk13_a___8
 risk13_specify
 risk12
 prox_cannabis
 prox_coke
 prox_crack
 prox_heroin
 prox_meth
 prox_hallu
 prox_club
 prox_other
 risk14
 risk15
 risk16
 risk17
 risk18
 risk_factors_complete
 vp1
 vp2
 vp3___1
 vp3___2
 vp3___3
 vp3___4
 vp3___5
 vp3___6
 vp3___7
 vp3___8
 vp3___9
 vp3_specify
 vp4
 vp5
 vp6
 vp7
 vp8
 vp9
 vp10
 vp11
 vp12
 vp13
 vp14
 vp15
 vp16
 vp17
 vp18
 vp19
 vp20
 vp21
 vp22
 vp23
 vp24
 vp25
 vp26
 vp27
 vp28
 vp29
 vp30
 vp31
 vp32
 vp33
 vp34
 vp35
 vp36
 vp37
 vp38
 vp39
 vp40
 vp41
 vp42
 vp43
 vp44
 vp45
 vp46
 vp47
 vp48
 vp49
 vp50___1
 vp50___2
 vp50___3
 vp50___4
 vp50___5
 vp50___6
 vp51
 vp52
 vp53
 vp53_specify
 vaginal_practices_complete
 last_mentral_period
 phys1
 phys1_abnormalities
 phys2
 phys3
 phys3_abnormalities
 phys4
 phys4_abnormalities
 phys5
 phys6___1
 phys6___2
 phys6___3
 phys6___4
 phys6___5
 phys6___6
 phys6___7
 phys6_specify
 phys7
 phys7_specify
 phys8
 phys9
 phys10
 phys10_abnormalities
 phys11
 phys12
 phys13
 phys14
 phys15
 phys15_specify
 phys16
 phys17
 phys18
 phys19
 phys20
 phys_comments
 phys_examiner
 phys_date
 physical_exam_complete
 screen_fail
 control_group
 rapidtest_lab
 rapidtest_lab_specify
 pregnancy_lab
 pregnancy_lab_specify
 psa_lab
 psa_lab_specify
 estrogen_done
 estrogen_lab
 progesterone_done
 progesterone_lab
 discharge_lab
 discharge_lab_specify
 clue_cell_lab
 clue_cell_lab_specify
 whiff_lab
 whiff_lab_specify
 ph_lab
 ph_lab_specify
 yeast_lab
 yeast_lab_specify
 amsel_lab
 nugent_lab
 whole_blood_lab
 rectal_swab_lab
 cvl_lab
 cytobrush_lab
 chlamydia_lab
 chlamydia_lab_specify
 gonorrhea_lab
 gonorrhea_lab_specify
 trichomonas_lab
 trichomonas_lab_specify
 consent_storage
 covid_rapid
 covid_igg
 laboratory_results_complete
 medgyn2_v2
 medgyn4_v2
 medgyn3_v2
 medgyn3_a_v2
 medgyn3_b_v2
 medgyn6_v2
 medgyn17_v2
 medgyn18_v2
 medgyn19_v2
 medgyn20_v2
 medgyn22_v2
 medgyn28_v2
 medgyn29_v2
 medgyn30_v2
 medgyn30_specify_v2
 medical_history_1m_complete
 risk3_v2
 risk4_v2
 risk5_v2
 risk6_v2
 risk7_v2
 risk8_v2
 risk9_v2
 risk10_v2
 risk13_v2
 risk13_a_v2___1
 risk13_a_v2___2
 risk13_a_v2___3
 risk13_a_v2___4
 risk13_a_v2___5
 risk13_a_v2___6
 risk13_a_v2___7
 risk13_a_v2___8
 risk13_specify_v2
 prox_cannabis_v2
 prox_coke_v2
 prox_crack_v2
 prox_heroin_v2
 prox_meth_v2
 prox_hallu_v2
 prox_club_v2
 prox_other_v2
 risk_factors_1m_complete
 vp1_v2
 vp2_v2
 vp3_v2___1
 vp3_v2___2
 vp3_v2___3
 vp3_v2___4
 vp3_v2___5
 vp3_v2___6
 vp3_v2___7
 vp3_v2___8
 vp3_v2___9
 vp3_specify_v2
 vp4_v2
 vp10_v2
 vp11_v2
 vp12_v2
 vp15_v2
 vp16_v2
 vp17_v2
 vp19_v2
 vp20_v2
 vp21_v2
 vp23_v2
 vp24_v2
 vp25_v2
 vp30_v2
 vp31_v2
 vp32_v2
 vp34_v2
 vp35_v2
 vp36_v2
 vp39_v2
 vp40_v2
 vp41_v2
 vp43_v2
 vp44_v2
 vp45_v2
 vp53_v2
 vaginal_practices_1m_complete
 consent
 verbal_consent_complete
 interviewer_name_v2
 date_today_v2
 dem8_v2
 dem9_v2
 dem10_v2
 sociodemogrphcs_6mspplmntl_cmplt
 medgyn1_v3
 medgyn2_v3
 medgyn4_v3
 medgyn3_v3
 medgyn3_a_v3
 medgyn3_b_v3
 medgyn5_v3
 medgyn6_v3
 medgyn7_v3
 medgyn8_v3
 medgyn17_v3
 medgyn18_v3
 medgyn19_v3
 medgyn20_v3
 medgyn22_v3
 medgyn23_v3___1
 medgyn23_v3___2
 medgyn23_v3___3
 medgyn23_v3___4
 medgyn23_v3___5
 medgyn23_v3___6
 medgyn23_v3___7
 medgyn23_v3___8
 medgyn23_v3___9
 medgyn23_v3___10
 medgyn23_a_v3
 medgyn28_v3
 medgyn29_v3
 medgyn29_v3_specify
 medical_history_6mspplmntl_cmplt
 risk3_v3
 risk4_v3
 risk5_v3
 risk6_v3
 risk7_v3
 risk8_v3
 risk9_v3
 risk10_v3
 risk13_v3
 risk13_a_v3___1
 risk13_a_v3___2
 risk13_a_v3___3
 risk13_a_v3___4
 risk13_a_v3___5
 risk13_a_v3___6
 risk13_a_v3___7
 risk13_a_v3___8
 risk13_specify_v3
 risk12_v3
 prox_cannabis_v3
 prox_coke_v3
 prox_crack_v3
 prox_heroin_v3
 prox_meth_v3
 prox_hallu_v3
 prox_club_v3
 prox_other_v3
 risk14_v3
 risk15_v3
 risk16_v3
 risk17_v3
 risk18_v3
 risk_factors_6msupplementl_cmplt
 vp1_v3
 vp2_v3
 vp3_v3___1
 vp3_v3___2
 vp3_v3___3
 vp3_v3___4
 vp3_v3___5
 vp3_v3___6
 vp3_v3___7
 vp3_v3___8
 vp3_v3___9
 vp3_specify_v3
 vp4_v3
 vp10_v3
 vp11_v3
 vp12_v3
 vp13_v3
 vp14_v3
 vp15_v3
 vp16_v3
 vp17_v3
 vp18_v3
 vp19_v3
 vp20_v3
 vp21_v3
 vp22_v3
 vp23_v3
 vp24_v3
 vp25_v3
 vp26_v3
 vp30_v3
 vp31_v3
 vp32_v3
 vp33_v3
 vp34_v3
 vp35_v3
 vp36_v3
 vp37_v3
 vp38_v3
 vp39_v3
 vp40_v3
 vp41_v3
 vp42_v3
 vp43_v3
 vp44_v3
 vp45_v3
 vp46_v3
 vp50_v3___1
 vp50_v3___2
 vp50_v3___3
 vp50_v3___4
 vp50_v3___5
 vp50_v3___6
 vp51_v3
 vp52_v3
 vp53_v3
 vp53_specify_v3
 vaginal_practcs_6mspplmntl_cmplt
 covid_1
 covid_2
 covid_3
 covid_4___1
 covid_4___2
 covid_4___3
 covid_4___4
 covid_4___5
 covid_5___1
 covid_5___2
 covid_5___3
 covid_5___4
 covid_5___5
 covid_6
 covid_7
 covid_8
 covid_9
 covid_10
 covid_12
 covid_13
 covid_14
 covid_15
 covid_16
 covid_17
 covid_18
 covid_19
 covid_20
 covid_21
 covid_22
 covid_23
 covid_24
 covid_25
 covid_26
 covid_27
 covid_28
 covid_29
 covid_30
 covid_31
 covid_32
 covid_33
 covid_34
 covid_35
 covid_36
 covid_37
 covid_38
 covid_39
 covid_40
 covid_41
 covid_42
 covid_43
 covid_44
 covid_45
 covid_46
 covid_47
 covid_48
 covid_49
 covid_50
 covid_51
 covid_52
 covid_53
 covid_54
 covid_55
 covid_56
 covid_57
 covid_58
 covid_59
 covid_60
 covid_61
 covid_62
 covid_63
 covid_64
 covid_65
 covid_66
 covid_67
 covid_68
 covid_69
 covid_70
 covid_71
 covid_72
 covid_73
 covid_74
 covid_75
 covid_76
 covid_77
 covid_78
 covid_79
 covid_80
 covid_81
 covid_82
 covid_83
 covid_84
 covid_85
 covid_86
 covid_87
 covid_88
 covid_89
 covid_90
 covid_91
 covid_92
 covid_93
 covid_94
 covid_95
 covid_96
 covid_97
 covid_98
 covid_99
 covid_100
 covid_101
 covid_102
 covid_103
 covid_104
 covid_106
 covid_107
 covid_108
 covid_109
 covid_110
 covid_111
 covid_112
 covid_113
 covid_115
 covid_116
 covid_117
 covid_118
 covid_119
 covid_120
 covid_121
 covid_122
 covid_123
 covid_124
 covid_125
 covid_126
 covid_127
 covid_128
 covid_129
 covid_130
 covid_131
 covid_132
 covid_133
 covid_134
 covid_135
 covid_136
 covid_137
 covid_138
 covid_139
 covid_140
 covid_141
 covid_142
 covid_143
 covid_144
 covid_145
 covid_146
 covid_147
 covid_148
 covid_149
 covid_150
 covid_151
 covid_152
 covid_153
 covid_154
 covid_155
 covid_156
 covid_157
 covid_158
 covid_159
 covid_160
 covid_161
 covid_162
 covid_163
 covid_164
 covid_165
 covid_166
 covid_167
 covid_168
 covid_169
 covid_170
 covid_171
 covid_172
 covid_173
 covid_174
 covid_175
 covid_176
 covid_177
 covid_178
 covid_179
 covid_180
 covid_181
 covid_182
 covid_183
 covid_184
 covid_185
 covid_186
 covid_187
 covid_189
 covid_192
 covid_193
 covid_194
 covid_195
 covid_196
 covid_197
 covid_198
 covid_199
 covid_200
 covid_201
 covid_203
 covid_204
 covid_205
 covid_206
 covid_207
 covid_208
 covid_209
 covid_210
 covid_211
 covid_212
 covid_213
 covid_214
 covid_215
 covid_216
 covid_217
 covid_218
 covid_219
 covid_220
 covid_221
 covid_222
 covid_223
 covid_224
 covid_225
 covid_226
 covid_227
 covid_228
 covid_229
 covid_230
 covid_231
 covid_232
 covid_233
 covid_234
 covid_235
 covid_236
 covid_237
 covid_239
 covid_240
 covid_241
 covid_242
 covid_243
 covid_244
 covid_245
 covid_246
 covid_247
 covid_248
 covid_249
 covid_250
 covid_251
 covid_252
 covid_253
 covid_254
 covid_255
 covid_256
 covid_257
 covid_258
 covid_259
 covid_260
 covid_261
 covid_262
 covid_263
 covid_264
 covid_265
 covid_266
 covid_267
 covid_268
 covid_questionnaire_complete
 from
 screen2
 screen4
 screen6
 screen8
 screen11
 screen12
 screen14
 screen16
 screen17
 screen18
 screen19
 screen20
 screen21
 screen22
 screen23
 screen41
 screen42
 screen25
 screen26
 screen27
 screen28
 screen30
 screen31
 screen32
 screen33
 screen34
 screen35
 screen36
 screen37
 screen38
 screening_complete
 consenyn
 consent_complete
 lab_nugent
 lab_nugent_no
 consent_storage_2
 covid_4___6
 covid_5___6
 covid_1_6mo
 covid_2_6mo
 covid_4_6mo___1
 covid_4_6mo___2
 covid_4_6mo___3
 covid_4_6mo___4
 covid_4_6mo___5
 covid_4_6mo___6
 covid_5_6mo___1
 covid_5_6mo___2
 covid_5_6mo___3
 covid_5_6mo___4
 covid_5_6mo___5
 covid_5_6mo___6
 covid_12_6mo
 covid_13_6mo
 covid_14_6mo
 covid_15_6mo
 covid_16_6mo
 covid_17_6mo
 covid_18_6mo
 covid_19_6mo
 covid_20_6mo
 covid_21_6mo
 covid_22_6mo
 covid_23_6mo
 covid_24_6mo
 covid_25_6mo
 covid_26_6mo
 covid_27_6mo
 covid_28_6mo
 covid_29_6mo
 covid_30_6mo
 covid_31_6mo
 covid_32_6mo
 covid_33_6mo
 covid_34_6mo
 covid_35_6mo
 covid_36_6mo
 covid_37_6mo
 covid_38_6mo
 covid_39_6mo
 covid_40_6mo
 covid_41_6mo
 covid_42_6mo
 covid_43_6mo
 covid_44_6mo
 covid_45_6mo
 covid_46_6mo
 covid_47_6mo
 covid_48_6mo
 covid_49_6mo
 covid_50_6mo
 covid_51_6mo
 covid_52_6mo
 covid_53_6mo
 covid_54_6mo
 covid_55_6mo
 covid_56_6mo
 covid_57_6mo
 covid_58_6mo
 covid_59_6mo
 covid_60_6mo
 covid_61_6mo
 covid_62_6mo
 covid_63_6mo
 covid_64_6mo
 covid_65_6mo
 covid_66_6mo
 covid_67_6mo
 covid_68_6mo
 covid_69_6mo
 covid_70_6mo
 covid_71_6mo
 covid_72_6mo
 covid_73_6mo
 covid_74_6mo
 covid_75_6mo
 covid_76_6mo
 covid_77_6mo
 covid_78_6mo
 covid_79_6mo
 covid_80_6mo
 covid_81_6mo
 covid_82_6mo
 covid_83_6mo
 covid_84_6mo
 covid_85_6mo
 covid_86_6mo
 covid_87_6mo
 covid_88_6mo
 covid_89_6mo
 covid_90_6mo
 covid_91_6mo
 covid_92_6mo
 covid_93_6mo
 covid_94_6mo
 covid_95_6mo
 covid_96_6mo
 covid_97_6mo
 covid_98_6mo
 covid_99_6mo
 covid_100_6mo
 covid_101_6mo
 covid_102_6mo
 covid_103_6mo
 covid_104_6mo
 covid_106_6mo
 covid_107_6mo
 covid_108_6mo
 covid_109_6mo
 covid_110_6mo
 covid_111_6mo
 covid_112_6mo
 covid_113_6mo
 covid_115_6mo
 covid_116_6mo
 covid_117_6mo
 covid_118_6mo
 covid_119_6mo
 covid_120_6mo
 covid_121_6mo
 covid_122_6mo
 covid_123_6mo
 covid_124_6mo
 covid_125_6mo
 covid_126_6mo
 covid_127_6mo
 covid_128_6mo
 covid_129_6mo
 covid_130_6mo
 covid_131_6mo
 covid_132_6mo
 covid_133_6mo
 covid_134_6mo
 covid_135_6mo
 covid_136_6mo
 covid_137_6mo
 covid_138_6mo
 covid_139_6mo
 covid_140_6mo
 covid_141_6mo
 covid_142_6mo
 covid_143_6mo
 covid_144_6mo
 covid_145_6mo
 covid_146_6mo
 covid_147_6mo
 covid_148_6mo
 covid_149_6mo
 covid_150_6mo
 covid_151_6mo
 covid_152_6mo
 covid_153_6mo
 covid_154_6mo
 covid_155_6mo
 covid_156_6mo
 covid_157_6mo
 covid_158_6mo
 covid_159_6mo
 covid_160_6mo
 covid_161_6mo
 covid_162_6mo
 covid_163_6mo
 covid_164_6mo
 covid_165_6mo
 covid_166_6mo
 covid_167_6mo
 covid_168_6mo
 covid_169_6mo
 covid_170_6mo
 covid_171_6mo
 covid_172_6mo
 covid_173_6mo
 covid_174_6mo
 covid_175_6mo
 covid_176_6mo
 covid_177_6mo
 covid_179_6mo
 covid_180_6mo
 covid_181_6mo
 covid_182_6mo
 covid_183_6mo
 covid_184_6mo
 covid_185_6mo
 covid_186_6mo
 covid_187_6mo
 covid_188_6mo
 covid_189_6mo
 covid_190_6mo
 covid_191_6mo
 covid_192_6mo
 covid_193_6mo
 covid_194_6mo
 covid_195_6mo
 covid_196_6mo
 covid_197_6mo
 covid_198_6mo
 covid_199_6mo
 covid_200_6mo
 covid_201_6mo
 covid_202_6mo
 covid_203_6mo
 covid_204_6mo
 covid_205_6mo
 covid_206_6mo
 covid_207_6mo
 covid_208_6mo
 covid_209_6mo
 covid_210_6mo
 covid_211_6mo
 covid_212_6mo
 covid_213_6mo
 covid_214_6mo
 covid_215_6mo
 covid_216_6mo
 covid_217_6mo
 covid_218_6mo
 covid_219_6mo
 covid_220_6mo
 covid_221_6mo
 covid_222_6mo
 covid_223_6mo
 covid_224_6mo
 covid_225_6mo
 covid_226_6mo
 covid_227_6mo
 covid_228_6mo
 covid_229_6mo
 covid_230_6mo
 covid_231_6mo
 covid_232_6mo
 covid_233_6mo
 covid_234_6mo
 covid_235_6mo
 covid_236_6mo
 covid_237_6mo
 covid_239_6mo
 covid_240_6mo
 covid_241_6mo
 covid_242_6mo
 covid_243_6mo
 covid_244_6mo
 covid_245_6mo
 covid_246_6mo
 covid_247_6mo
 covid_248_6mo
 covid_249_6mo
 covid_250_6mo
 covid_251_6mo
 covid_252_6mo
 covid_253_6mo
 covid_254_6mo
 covid_255_6mo
 covid_256_6mo
 covid_257_6mo
 covid_258_6mo
 covid_259_6mo
 covid_260_6mo
 covid_261_6mo
 covid_262_6mo
 covid_263_6mo
 covid_264_6mo
 covid_265_6mo
 covid_266_6mo
 covid_267_6mo
 covid_268_6mo
 covid_questionnaire_6mo_complete
 datos_sociodemogrficos_complete
 histrl_mdc_y_d_bsttrcgnclg_cmplt
 factores_de_riesgo_complete
 prcticas_vaginales_complete
 hstrl_mdc_y_d_bsttrcgnclg_1m_cmp
 factores_de_riesgo_1m_complete
 prcticas_vaginales_1m_complete
 datos_scdmgrfcs_6mspplmntl_cmplt
 hstrl_mdc_y_d_bsttrcgnclg_6mspp_
 factores_de_rsg_6mspplmntl_cmplt
 prcticas_vagnls_6mspplmntl_cmplt
 covid_4
 covid_6___1
 covid_6___2
 covid_6___3
 covid_6___4
 covid_6___5
 covid_238
 covid_6___6
 covid_3_6mo
 covid_6_6mo___1
 covid_6_6mo___2
 covid_6_6mo___3
 covid_6_6mo___4
 covid_6_6mo___5
 covid_6_6mo___6
 covid_238_6mo
;
LABEL  sociodemogrphcs_6mspplmntl_cmplt = "sociodemographics_6msupplemental_complete" ;
LABEL  medical_history_6mspplmntl_cmplt = "medical_history_6msupplemental_complete" ;
LABEL  risk_factors_6msupplementl_cmplt = "risk_factors_6msupplemental_complete" ;
LABEL  vaginal_practcs_6mspplmntl_cmplt = "vaginal_practices_6msupplemental_complete" ;
LABEL  histrl_mdc_y_d_bsttrcgnclg_cmplt = "historial_mdico_y_de_obstetriciaginecologa_complete" ;
LABEL  hstrl_mdc_y_d_bsttrcgnclg_1m_cmp = "historial_mdico_y_de_obstetriciaginecologa_1m_complete" ;
LABEL  datos_scdmgrfcs_6mspplmntl_cmplt = "datos_sociodemogrficos_6msupplemental_complete" ;
LABEL  hstrl_mdc_y_d_bsttrcgnclg_6mspp_ = "historial_mdico_y_de_obstetriciaginecologa_6msuppl_complete" ;
LABEL  factores_de_rsg_6mspplmntl_cmplt = "factores_de_riesgo_6msupplemental_complete" ;
LABEL  prcticas_vagnls_6mspplmntl_cmplt = "prcticas_vaginales_6msupplemental_complete" ;
FORMAT date_today yymmdd10.;
FORMAT medgyn1 yymmdd10.;
FORMAT medgyn3_b yymmdd10.;
FORMAT medgyn6 yymmdd10.;
FORMAT medgyn11 yymmdd10.;
FORMAT medgyn24 yymmdd10.;
FORMAT risk3 yymmdd10.;
FORMAT vp2 yymmdd10.;
FORMAT vp11 yymmdd10.;
FORMAT vp16 yymmdd10.;
FORMAT vp20 yymmdd10.;
FORMAT vp24 yymmdd10.;
FORMAT vp31 yymmdd10.;
FORMAT vp35 yymmdd10.;
FORMAT vp40 yymmdd10.;
FORMAT vp44 yymmdd10.;
FORMAT last_mentral_period yymmdd10.;
FORMAT phys_date yymmdd10.;
FORMAT medgyn3_b_v2 yymmdd10.;
FORMAT medgyn6_v2 yymmdd10.;
FORMAT risk3_v2 yymmdd10.;
FORMAT vp2_v2 yymmdd10.;
FORMAT vp11_v2 yymmdd10.;
FORMAT vp16_v2 yymmdd10.;
FORMAT vp20_v2 yymmdd10.;
FORMAT vp24_v2 yymmdd10.;
FORMAT vp31_v2 yymmdd10.;
FORMAT vp40_v2 yymmdd10.;
FORMAT date_today_v2 yymmdd10.;
FORMAT medgyn1_v3 yymmdd10.;
FORMAT medgyn3_b_v3 yymmdd10.;
FORMAT medgyn6_v3 yymmdd10.;
FORMAT risk3_v3 yymmdd10.;
FORMAT vp2_v3 yymmdd10.;
FORMAT vp11_v3 yymmdd10.;
FORMAT vp16_v3 yymmdd10.;
FORMAT vp20_v3 yymmdd10.;
FORMAT vp24_v3 yymmdd10.;
FORMAT vp31_v3 yymmdd10.;
FORMAT vp40_v3 yymmdd10.;
FORMAT screen32 yymmdd10.;
FORMAT screen35 yymmdd10.;
FORMAT covid_18_6mo yymmdd10.;
FORMAT covid_26_6mo yymmdd10.;
FORMAT covid_27_6mo yymmdd10.;
FORMAT covid_30_6mo yymmdd10.;
FORMAT covid_31_6mo yymmdd10.;
FORMAT covid_34_6mo yymmdd10.;
FORMAT covid_35_6mo yymmdd10.;
FORMAT covid_42_6mo yymmdd10.;
FORMAT covid_43_6mo yymmdd10.;
FORMAT covid_46_6mo yymmdd10.;
FORMAT covid_47_6mo yymmdd10.;
FORMAT covid_50_6mo yymmdd10.;
FORMAT covid_51_6mo yymmdd10.;
FORMAT covid_54_6mo yymmdd10.;
FORMAT covid_55_6mo yymmdd10.;
FORMAT covid_62_6mo yymmdd10.;
FORMAT covid_63_6mo yymmdd10.;
FORMAT covid_66_6mo yymmdd10.;
FORMAT covid_67_6mo yymmdd10.;
FORMAT covid_70_6mo yymmdd10.;
FORMAT covid_71_6mo yymmdd10.;
FORMAT covid_74_6mo yymmdd10.;
FORMAT covid_75_6mo yymmdd10.;
FORMAT covid_188_6mo yymmdd10.;
RUN;
