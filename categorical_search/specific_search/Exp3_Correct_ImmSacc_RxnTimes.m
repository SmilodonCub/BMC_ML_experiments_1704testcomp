clear all
clf
%Correct Initial Saccades Reaction Times

%Target Cue Present at Fixation
%Search_Exp3-Peanut-11-20-2015(02)      10 Targets
CuePresent(12).RxnTimes = [321 298 263 220 341 285 213 270 245 225 263 247 265 266 215 341 211 221 246 247 481 315 333 332 264 264 188 321 227 316 210 292 377 210 229 250 316 249];
%Search_Exp3-Peanut-11-20-2015          10 Targets
CuePresent(11).RxnTimes = [228 219 207 230 244 199 240 272 262 301 289 215 199 246 277 224 249 241 249 241 205 275 299 280 231 199 288 319 574 274 596 236 224 212 236 217 271 267 243 212 269];
%Search_Exp3-Peanut-11-19-2015          10 Targets
CuePresent(10).RxnTimes = [250 297 298 222 214 372 319 248 286 232 249 217 242 304 243 465 251 290 268 247 242 283 231 246 245 222 229 447 243 290 312 270 220 361 238 363 332 312 317 324 331 549 238 261 223];
%Search_Exp3-Peanut-11-19-2015(02)      10 Targets
CuePresent(9).RxnTimes = [235 249 235 320 289 234 214 374 249 271 310 213 693 283 302 234 286 217 288 278 439 248 262 314 192 275 218 188 267 564 285 197 271 227 230 282];
%Search_Exp3-Peanut-11-18-2015          9 Targets
CuePresent(8).RxnTimes = [217 210 280 215 272 207 255 293 249 279 248 204 199 228 232 225 214 245 279 241 244 249 299 350 224 247 340 330 287 282 197 274 241 235 234 264 299 218 279 352 291 252 327 207 293 249 237 275 272 330 299 306 268 214 222 264 484 223 270 236 270 275 215 249 199 225];
%Search_Exp3-Peanut-11-18-2015(02)      9 Targets
%CuePresent(6).RxnTimes = [341 205 219 224 249 214 228 222 205 329 554 546 329 330 266 322 1081 402 219 313 324 242 263 216 500 635 210 250 216 303 235 213 447 212 237 253 219 268 519 194 301 198 227 356];
%Search_Exp3-Peanut-11-16-2015          9 Targets
CuePresent(7).RxnTimes = [256 236 324 220 268 264 253 290 349 250 228 301 312 253 254 368 216 314 208 242 387 220 222 251 224 290 227 340 301 270 291 264 300 227 248 247 337 243 215 211 228 282 300 213 244 262 215 236 216 484 224 309 366 236 277 251 309 328 246];
%Search_Exp3-Peanut-11-13-2015          8 Targets
CuePresent(6).RxnTimes = [240 251 372 591 229 324 665 333 214 468 390 239 323 237 463 313 334 499 312 275 318 326 524 288 586 399 248 378 375 340 715 249 270 383 1298 468 290 364 263 313 253 242 371 237 689 363 283 1042 249 228 334 250 299 247 1353 217 287 239 243 297 237 224 310 331 264 257 308 386 327];
%Search_Exp3-Peanut-09-29-2015          5 targets
CuePresent(1).RxnTimes = [241 281 315 580 291 251 259 377 263 323 257 280 296 321 253 263 290 641 264 266 425 256 423 281 304 225 212 1234 246 271 226 274 234 244 492 214 277 242 440 430 316 240 298 242 248 249 297 419 665 229 628 232];
%Search_Exp3-Peanut-09-30-2015          5 targets
CuePresent(2).RxnTimes = [256 227 291 262 423 327 342 349 305 293 289 263 1302 269 246 368 423 316 270 657 233 235 363 299 321 273 271 221 339 1279 248 273 279 230 262 413 288 232 308 599 262 523 265 398 273 222 332 293 291 290 292 327 291 541 287 299 235 464 240 240 290 232 423 223 256 263 375 378 314 574 262];
%Search_Exp3-Peanut-11-10-2015          7 Targets
CuePresent(3).RxnTimes = [383 742 421 283 1306 224 218 218 224 256 347 298 247 1322 287 246 427 239 299 466 490 282 370 228 246 223 306 356 278 385 431 299 371 366 337 1271 296 253 300 250 330 249 396 316 303 297 241 1096 1335 475 593 233 545 1297 336 894 300 346 493 414 265];
%Search_Exp3-Peanut-11-11-2015          7 Targets
CuePresent(4).RxnTimes = [266 416 299 268 332 383 314 264 232 312 276 546 315 251 564 301 492 245 269 281 355 550 305 521 734 245 304 211 224 293 249 345 633 775 333 289 228 284 651 565 425 693 542 442 675 312 414 244 301 315 242 327];
%Search_Exp3-Peanut-11-12-2015          7 Targets
CuePresent(5).RxnTimes = [248 1552 751 741 1177 269 228 323 426 338 388 227 1001 325 831 235 227 367 282 350 514 350 451 360 347 776 520 609 295 1066 1132 222 326 277 437 648 252 697 297 376 437 284 968 292 550 240 497 1403 230 350 257 546 312 239 881 263 430 230 543 328 339 716 348 449 223 1397 686 280 1217 347 314 501 1238 348 220];




means_CP = zeros(1, size(CuePresent,2));
std_CP = zeros(1, size(CuePresent,2));

for i = 1:(size(CuePresent,2))
    CuePresent(i).Mean = mean(CuePresent(i).RxnTimes);
    means_CP(1,i) = mean(CuePresent(i).RxnTimes);
    CuePresent(i).Std = std(CuePresent(i).RxnTimes);
    std_CP(1,i) = std(CuePresent(i).RxnTimes);
end


%Uncued Fixation
%Search_Exp3-Peanut-11-20-2015(01)      10 Targets
UnCued(12).RxnTimes = [214 266 220 235 247 263 215 248 313 287 244 322 325 302 203 217 220 290 272 240 243 238 211 213 299 249 215 230 249 221 199 333 235 364 265 280 233 191];
%Search_Exp3-Peanut-11-20-2015(03)      10 Targets
UnCued(11).RxnTimes = [276 197 267 249 208 349 304 278 253 341 383 299 250 217 392 201 192 267 261 300 234 220 282 303 273 377 235 493];
%Search_Exp3-Peanut-11-19-2015(01)      10 Targets
UnCued(10).RxnTimes = [274 289 265 281 278 590 244 221 235 273 216 238 260 293 286 422 308 249 256 285 493 259 249 222 216 269 216 209 302 220 255 262 219 297 529 219 299 295 288 252 217 214];
%Search_Exp3-Peanut-11-19-2015(03)      10 Targets
UnCued(9).RxnTimes = [316 262 250 218 241 340 277 325 318 249 276 265 246 273 260 294 250 249 335 300 293 336 333 441 747 266 270 267 436 276 289 257 278 248 217 251 213 213 391];
%Search_Exp3-Peanut-11-18-2015(01)      9 Targets 
UnCued(8).RxnTimes = [242 234 264 199 349 318 281 264 213 289 291 213 242 216 639 275 200 284 200 265 290 498 244 291 365 362 280 197 235 254 199 238 347 200 222 300 286 289 252 266 200 276 241 263 233 240 293 269 230 248 344 352 217 249 295 467 274 298 236 244 252 280 250 194 267 253 228 256 207 221 211 200 470 466 265];
%Search_Exp3-Peanut-11-16-2015(01)      9 Targets
UnCued(7).RxnTimes = [283 278 274 213 216 268 392 251 274 249 234 265 212 297 215 255 253 213 206 286 248 297 785 294 218 267 215 246 245 249 234 214 277 380 351 282 214 337 254 313 302 254 220 211 285 299 216 260 419 238 301 244 220 300 252 277 208 279 279 264 225];
%Search_Exp3-Peanut-11-13-2015(01)      8 Targets
UnCued(6).RxnTimes = [227 675 276 207 440 221 326 365 289 216 377 481 289 214 1087 264 263 294 225 329 259 303 650 246 463 213 239 444 416 349 281 227 298 245 251 250 291 250 227 264 284 227 285 299 350 246 473 451 547 293 199 265 284 270 272 314 389 993 290 190 323 193 325 214];
%Search_Exp3-Peanut-09-29-2015(01)      5 targets
UnCued(1).RxnTimes = [355 349 249 289 239 227 312 298 209 378 300 277 239 249 294 267 216 385 223 284 227 318 329 215 221 290 242 209 375 299 330 214 263 280 520 274 532 371 265 267 208 272 265 215 232 356 320 216 268 228];
%Search_Exp3_NOCUE-Peanut-09-30-2015    5 Targets
UnCued(2).RxnTimes = [236 229 339 541 287 222 261 263 342 450 263 263 301 264 345 361 262 299 400 295 223 654 283 420 234 230 469 223 300 501 274 814 276 216 215 229 739 313 328 440 361 272 1230 265 313 375 263 943 218 216 274 309 245 1168 1130 300 496 271 283 299];
%Search_Exp3-Peanut-11-10-2015(01)      7 Targets
UnCued(3).RxnTimes = [299 305 342 242 200 199 304 339 215 465 1103 1083 395 300 289 214 325 926 250 686 249 1081 637 246 194 314 248 1202 322 410 1031 748 1001 335 1283 598 251 800 384 874 191 1304 249 317 292 277 333 214 372 264 875 772 283 391 1082];
%Search_Exp3-Peanut-11-11-2015(01)      7 Targets
UnCued(4).RxnTimes = [265 265 226 324 324 320 919 252 249 218 263 300 238 357 337 223 220 323 1318 333 275 833 518 339 516 322 219 321 1103 321 259 240 422 356 590 255 893 211 314 1620 261 315 317 275 1008 1291 215 341 305 417 1137 229];
%Search_Exp3-Peanut-11-12-2015(01)      7 Targets
UnCued(5).RxnTimes = [264 255 268 341 242 285 278 496 291 1167 399 1136 1540 238 572 422 384 263 327 472 330 1404 223 785 318 284 243 270 242 341 274 376 932 552 226 270 448 639 1597 264 281 272 299 415 776 1233 1324 313 271 244 251 1083 500 269 237 776 496 276 349 1171 352 258 752 226 1017 922 640 1168];




means_UC = zeros(1, size(CuePresent,2));
std_UC = zeros(1, size(CuePresent,2));

for i = 1:(size(UnCued,2))
    UnCued(i).Mean = mean(UnCued(i).RxnTimes);
    means_UC(1,i) = mean(UnCued(i).RxnTimes);
    UnCued(i).Std = std(UnCued(i).RxnTimes);
    std_UC(1,i) = std(UnCued(i).RxnTimes);
end


figure(2); 
errorbar(1:size(CuePresent,2), means_CP, std_CP, 'or','LineStyle', 'none','MarkerSize', 8);
hold on; 
errorbar(1:size(CuePresent,2), means_UC, std_UC, 'sg','LineStyle', 'none','MarkerSize', 8);
ylim([0 900]);
set(gca, 'XTick', 1:12)
set(gca, 'XTickLabel', [ 5 5 7 7 7 8 9 9 10 10 10 10 ])
xlabel('# Specific Search Targets per Block')
ylabel('Reaction Time (msec)')
legend('Cued (Specific) Search','UnCued Search');
title('a look at the first 2 blocks of the day')

UC_5 = cat(2, UnCued(1).RxnTimes, UnCued(2).RxnTimes );
CP_5 = cat(2, CuePresent(1).RxnTimes, CuePresent(2).RxnTimes );
UC_mean5 = mean(UC_5);
CP_mean5 = mean(CP_5);
UC_std5 = std(UC_5);
CP_std5 = std(CP_5);
UC_7 = cat(2, UnCued(3).RxnTimes, UnCued(4).RxnTimes, UnCued(5).RxnTimes );
CP_7 = cat(2, CuePresent(3).RxnTimes, CuePresent(4).RxnTimes, CuePresent(5).RxnTimes );
UC_mean7 = mean(UC_7);
CP_mean7 = mean(CP_7);
UC_std7 = std(UC_7);
CP_std7 = std(CP_7);
UC_8 = UnCued(6).RxnTimes;
CP_8 = CuePresent(6).RxnTimes;
UC_mean8 = mean(UC_8);
CP_mean8 = mean(CP_8);
UC_std8 = std(UC_8);
CP_std8 = std(CP_8);
UC_9 = cat(2, UnCued(7).RxnTimes, UnCued(8).RxnTimes );
CP_9 = cat(2, CuePresent(7).RxnTimes, CuePresent(8).RxnTimes );
UC_mean9 = mean(UC_9);
CP_mean9 = mean(CP_9);
UC_std9 = std(UC_9);
CP_std9 = std(CP_9);
UC_10 = cat(2, UnCued(9).RxnTimes, UnCued(10).RxnTimes, UnCued(11).RxnTimes, UnCued(12).RxnTimes );
CP_10 = cat(2, CuePresent(9).RxnTimes, CuePresent(10).RxnTimes, CuePresent(11).RxnTimes, CuePresent(12).RxnTimes );
UC_mean10 = mean(UC_10);
CP_mean10 = mean(CP_10);
UC_std10 = std(UC_10);
CP_std10 = std(CP_10);


UC_means = [ UC_mean5, UC_mean7, UC_mean8, UC_mean9, UC_mean10 ];
UC_stds = [ UC_std5, UC_std7, UC_std8, UC_std9, UC_std10 ];
CP_means = [ CP_mean5, CP_mean7, CP_mean8, CP_mean9, CP_mean10 ];
CP_stds = [ CP_std5, CP_std7, CP_std8, CP_std9, CP_std10 ];






figure(3)
errorbar(1:5, CP_means, CP_stds,'or','LineStyle', 'none','MarkerSize', 8);
hold on;
errorbar(1:5, UC_means, UC_stds, 'sg','LineStyle', 'none','MarkerSize', 8);
ylim([0 800]);
set(gca, 'XTick', 1:5)
set(gca, 'XTickLabel', [ 5 7 8 9 10 ])
xlabel('# Specific Search Targets per Block')
ylabel('Reaction Time (msec)')
legend('Cued (Specific) Search','UnCued Search');
title('Reaction Times for Target Present Trials as a Fxn of #Targets/Block')


CP_total = [ 75.3; 86; 74; 64; 90.6; 82.7; 81.3; 82; 78; 86; 74; 76 ];
CP_TP = [ 69.3; 84.4; 74.7; 66.3; 89.2; 84.2; 82.9; 83.3; 75.9; 87.9; 71.0; 80 ];
CP_TA = [ 83.9; 88.9; 72.9; 60.3; 93.0; 80; 79.0; 80; 80.9; 83.3; 78.9; 70 ];
UC_total = [ 75.3; 79.3; 73.3; 70.6; 85.3; 79.3; 76.7; 89.3; 74; 80; 57; 76 ];
UC_TP = [ 72.7; 78.2; 71.4; 73.3; 88.5; 78.3; 79.3; 88.6; 80; 76.7; 60.6; 70.3 ];
UC_TA = [ 79.0; 80.9; 76.3; 66.7; 81.0; 81.0; 72.4; 90.6; 65; 85; 51.2; 86.1 ];

CP_total_means = [ mean([75.3, 86]); mean([74, 64, 90.6]); 82.7; mean([81.3, 82]); mean([78, 86, 74, 76]) ];
CP_TP_means = [ mean([69.3, 84.4]); mean([74.7, 66.3, 89.2]); 84.2; mean([82.9, 83.3]); mean([75.9, 87.9, 71.0, 80]) ];
CP_TA_means = [ mean([83.9, 88.9]); mean([72.9, 60.3, 93.0]); 80; mean([79.0, 80]); mean([80.9, 83.3, 78.9, 70]) ];
UC_total_means = [ mean([75.3, 79.3]); mean([73.3, 70.6, 85.3]); 79.3; mean([76.7, 89.3]); mean([74, 80, 57, 76]) ];
UC_TP_means = [ mean([72.7, 78.2]); mean([71.4, 73.3, 88.5]); 78.3; mean([79.3, 88.6]); mean([80, 76.7, 60.6, 70.3]) ];
UC_TA_means = [ mean([79.0, 80.9]); mean([76.3, 66.7, 81.0]); 81.0; mean([72.4, 90.6]); mean([65, 85, 51.2, 86.1]) ];

CP_total_std = [ std([75.3, 86]); std([74, 64, 90.6]); std(82.7); std([81.3, 82]); std([78, 86, 74, 76]) ];
CP_TP_std = [ std([69.3, 84.4]); std([74.7, 66.3, 89.2]); std(84.2); std([82.9, 83.3]); std([75.9, 87.9, 71.0, 80]) ];
CP_TA_std = [ std([83.9, 88.9]); std([72.9, 60.3, 93.0]); std(80); std([79.0, 80]); std([80.9, 83.3, 78.9, 70]) ];
UC_total_std = [ std([75.3, 79.3]); std([73.3, 70.6, 85.3]); std(79.3); std([76.7, 89.3]); std([74, 80, 57, 76]) ];
UC_TP_std = [ std([72.7, 78.2]); std([71.4, 73.3, 88.5]); std(78.3); std([79.3, 88.6]); std([80, 76.7, 60.6, 70.3]) ];
UC_TA_std = [ std([79.0, 80.9]); std([76.3, 66.7, 81.0]); std(81.0); std([72.4, 90.6]); std([65, 85, 51.2, 86.1]) ];


CP_TP_ImmS = [ 90.9; 89.6; 92.3; 91.3; 91.3; 89.5; 85.2; 91.1; 89.6; 89.6; 91.9; 90 ];
CP_TA_ImmS = [ 56.5; 72.2; 88.1; 93.1; 89.5; 80; 64.5; 68.3; 80.9; 69.0; 81.6; 70 ];
UC_TP_ImmS = [ 85.2; 90.8; 89.0; 84.4; 89.6; 92.3; 86.9; 89.7; 86.7; 93.3; 86.8; 90.6 ];
UC_TA_ImmS = [ 61.3; 76.2; 88.1; 85; 90.5; 79.3; 72.4; 67.9; 77.5; 65; 95.0; 83.3];

CP_TP_ImmS_means = [ mean([90.9, 89.6]); mean([92.3, 91.3, 91.3]); 89.5; mean([85.2, 91.1]); mean([89.6, 89.6, 91.9, 90]) ];
CP_TA_ImmS_means = [ mean([56.5, 72.2]); mean([88.1, 93.1, 89.5]); 80; mean([64.5, 68.3]); mean([80.9, 69.0, 81.6, 70]) ];
UC_TP_ImmS_means = [ mean([85.2, 90.8]); mean([89.0, 84.4, 89.6]); 92.3; mean([86.9, 89.7]); mean([86.7, 93.3, 86.8, 90.6]) ];
UC_TA_ImmS_means = [ mean([61.3, 76.2]); mean([88.1, 85, 90.5]); 79.3; mean([72.4, 67.9]); mean([77.5, 65, 95.0, 83.3])];

CP_TP_ImmS_std = [ std([90.9, 89.6]); std([92.3, 91.3, 91.3]); std(89.5); std([85.2, 91.1]); std([89.6, 89.6, 91.9, 90]) ];
CP_TA_ImmS_std = [ std([56.5, 72.2]); std([88.1, 93.1, 89.5]); std(80); std([64.5, 68.3]); std([80.9, 69.0, 81.6, 70]) ];
UC_TP_ImmS_std = [ std([85.2, 90.8]); std([89.0, 84.4, 89.6]); std(92.3); std([86.9, 89.7]); std([86.7, 93.3, 86.8, 90.6]) ];
UC_TA_ImmS_std = [ std([61.3, 76.2]); std([88.1, 85, 90.5]); std(79.3); std([72.4, 67.9]); std([77.5, 65, 95.0, 83.3])];



figure('Position',[100, 200, 900, 700])
subplot(2,2,1)
errorbar(1:5, CP_total_means, CP_total_std,'xk','LineStyle', 'none','MarkerSize', 8);
hold on;
errorbar(1:5, CP_TP_means, CP_TP_std, 'sg','LineStyle', 'none','MarkerSize', 8);
errorbar(1:5, CP_TA_means, CP_TA_std, 'om','LineStyle', 'none','MarkerSize', 8);
ylim([0 100]);
set(gca, 'XTick', 1:5)
set(gca, 'XTickLabel', [ 5 7 8 9 10 ])
xlabel('# Specific Search Targets per Block')
ylabel('Performance (%)')
legend('Overall','Target','NO Target', 'Location', 'SouthEast');
title('Cue Present Performance')

subplot(2,2,2)
errorbar(1:5, UC_total_means, UC_total_std,'xk','LineStyle', 'none','MarkerSize', 8);
hold on;
errorbar(1:5, UC_TP_means, UC_TP_std, 'sg','LineStyle', 'none','MarkerSize', 8);
errorbar(1:5, UC_TA_means, UC_TA_std, 'om','LineStyle', 'none','MarkerSize', 8);
ylim([0 100]);
set(gca, 'XTick', 1:5)
set(gca, 'XTickLabel', [ 5 7 8 9 10 ])
xlabel('# Specific Search Targets per Block')
ylabel('Performance (%)')
legend('Overall','Target','NO Target', 'Location', 'SouthEast');
title('UnCued Performance')

subplot(2,2,3)
errorbar(1:5, CP_TP_ImmS_means, CP_TP_ImmS_std,'sr','LineStyle', 'none','MarkerSize', 8);
hold on;
errorbar(1:5, CP_TA_ImmS_means, CP_TA_ImmS_std, 'sb','LineStyle', 'none','MarkerSize', 8);
ylim([0 100]);
set(gca, 'XTick', 1:5)
set(gca, 'XTickLabel', [ 5 7 8 9 10 ])
xlabel('# Specific Search Targets per Block')
ylabel('Performance (%)')
legend('Target Present','No Target', 'Location', 'SouthEast');
title('Cue Present Immediate Saccades')

subplot(2,2,4)
errorbar(1:5, UC_TP_ImmS_means, UC_TP_ImmS_std,'sr','LineStyle', 'none','MarkerSize', 8);
hold on;
errorbar(1:5, UC_TA_ImmS_means, UC_TA_ImmS_std, 'sb','LineStyle', 'none','MarkerSize', 8);
ylim([0 100]);
set(gca, 'XTick', 1:5)
set(gca, 'XTickLabel', [ 5 7 8 9 10 ])
xlabel('# Specific Search Targets per Block')
ylabel('Performance (%)')
legend('Target Present','NO Target', 'Location', 'SouthEast');
title('UnCued Immediate Saccades')