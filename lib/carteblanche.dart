// ignore_for_file: unused_label

import 'dart:math';

// Listener 4725 CarteBlanche
// Determine clue numbers

int A = 0;
int B = 0;
int CC = 0;
int D = 0;
int E = 0;
int F = 0;
int G = 0;
int H = 0;
int I = 0;
int J = 0;
int K = 0;
int L = 0;
int M = 0;
int N = 0;
int O = 0;
int P = 0;
int Q = 0;
int RR = 0;
int S = 0;
int T = 0;
int U = 0;
int V = 0;
int W = 0;
int X = 0;
int Y = 0;
int Z = 0;
void main(List<String> args) {
  var digits = List.generate(26, (index) => index + 1);
  var used = <int>[];
  var trace = <String>[];
  void undo() {
    used.removeLast();
    trace.removeLast();
  }

  loopS:
  for (var d in digits.where((element) => !used.contains(element))) {
    S = d;
    used.add(d);
    trace.add('S=$S');
    loopH:
    for (var d in digits.where((element) => !used.contains(element))) {
      H = d;
      used.add(d);
      trace.add('H=$H');
      loopY:
      for (var d in digits.where((element) => !used.contains(element))) {
        Y = d;
        // if (Y < H) continue;
        var D20 = pow((S * H), Y);
        if (D20 < 1) continue;
        if (D20 > 47) {
          undo();
          continue loopH;
        }
        used.add(d);
        trace.add('Y=$Y');
        // print('$trace');
        // print('D20=$D20');
        loopE:
        for (var d in digits.where((element) => !used.contains(element))) {
          E = d;
          // if (E < H || E < S) continue;
          var A5 = Y + E;
          var A7 = H * E;
          var A20 = Y * E;
          if (A5 < 1) continue;
          if (A5 > 47) {
            undo();
            continue loopY;
          }
          if (A7 <= A5) continue;
          if (A7 >= A20) continue;
          if (A20 <= A7) continue;
          if (A20 > 47) {
            undo();
            continue loopY;
          }
          used.add(d);
          trace.add('E=$E');
          // print('$trace');
          // print('D20=$D20, A5=$A5, A7=$A7, A20=$A20');
          loopRR:
          for (var d in digits.where((element) => !used.contains(element))) {
            RR = d;
            // if (RR > E || RR > Y) {
            //   undo();
            //   continue loopE;
            // }
            // if (RR < H || RR < S) continue;
            var A2 = E - RR;
            var A11 = RR * Y + E;
            var A23 = RR + Y * E; // 47
            var D15 = E * RR;
            if (A2 <= 1 || A2 >= A5) continue;
            if (A11 <= A7) continue;
            if (A11 >= A20) {
              undo();
              continue loopE;
            }
            if (A23 <= A20) continue;
            if (A23 > 47) {
              undo();
              continue loopE;
            }
            if (D15 <= 1) continue;
            if (D15 >= D20) {
              undo();
              continue loopE;
            }
            used.add(d);
            trace.add('RR=$RR');
            // print('$trace');
            //
            print(
                'D20=$D20, A5=$A5, A7=$A7, A20=$A20, A2=$A2, A11=$A11, A23=$A23, D15=$D15');
            loopU:
            for (var d in digits.where((element) => !used.contains(element))) {
              U = d;
              var A6 = S * U + E;
              var A10 = U * RR;
              var D1 = H + U - E;
              var D7 = U * S;
              var D17 = H * U * H;
              var D23 = Y * U;
              if (A6 <= A5) continue;
              if (A6 >= A10) continue;
              if (A10 <= A7) continue;
              if (A10 >= A11) {
                undo();
                continue loopRR;
              }
              if (D1 <= 0) continue;
              if (D1 >= D7) continue;
              if (D7 <= D1) continue;
              if (D7 >= D17) continue;
              if (D17 <= D15) continue;
              if (D17 >= D20) {
                undo();
                continue loopRR;
              }
              if (D23 <= D20) continue;
              if (D23 > 47) {
                undo();
                continue loopRR;
              }
              used.add(d);
              trace.add('U=$U');
              // print('$trace');
              //
              print(
                  'D20=$D20, A5=$A5, A7=$A7, A20=$A20, A2=$A2, A11=$A11, A23=$A23, D15=$D15, A6=$A6, A10=$A10, D1=$D1, D7=$D7, D17=$D17, D23=$D23');
              loopO:
              for (var d
                  in digits.where((element) => !used.contains(element))) {
                O = d;
                var A18 = RR * O + Y;
                var D8 = O - RR;
                var D10 = S * O;
                var D14 = H * O;
                var D21 = O * RR;

                if (A18 <= A11) continue;
                if (A18 >= A20) {
                  undo();
                  continue loopU;
                }
                if (D8 <= D7) continue;
                if (D8 >= D15) {
                  undo();
                  continue loopU;
                }
                if (D8 >= D10) continue;
                if (D10 <= D8) continue;
                if (D10 >= D15) {
                  undo();
                  continue loopU;
                }
                if (D10 >= D14) continue;
                if (D14 <= D10) continue;
                if (D14 >= D15) {
                  undo();
                  continue loopU;
                }
                if (D21 <= D15) continue;
                if (D21 >= D23) {
                  undo();
                  continue loopU;
                }
                used.add(d);
                trace.add('O=$O');
                // print('$trace');
                //
                print(
                    'D20=$D20, A5=$A5, A7=$A7, A20=$A20, A2=$A2, A11=$A11, A23=$A23, D15=$D15, A6=$A6, A10=$A10, D1=$D1, D7=$D7, D17=$D17, D23=$D23, A18=$A18, D8=$D8, D10=$D10, D14=$D14, D21=$D21');
                loopT:
                for (var d
                    in digits.where((element) => !used.contains(element))) {
                  T = d;
                  var A16 = T + O;
                  var A17 = U + T + E;
                  var D3 = T - O - E;
                  var D24 = H * U + T;
                  if (A16 <= A11) continue;
                  if (A16 >= A17) continue;
                  if (A16 >= A18) {
                    undo();
                    continue loopO;
                  }
                  if (A17 <= A16) continue;
                  if (A17 >= A18) {
                    undo();
                    continue loopO;
                  }
                  if (D3 <= D1) continue;
                  if (D3 >= D8) {
                    undo();
                    continue loopO;
                  }
                  if (D24 <= D23) continue;
                  if (D24 > 47) {
                    undo();
                    continue loopO;
                  }
                  used.add(d);
                  trace.add('T=$T');
                  // print('$trace');
                  //
                  print(
                      'D20=$D20, A5=$A5, A7=$A7, A20=$A20, A2=$A2, A11=$A11, A23=$A23, D15=$D15, A6=$A6, A10=$A10, D1=$D1, D7=$D7, D17=$D17, D23=$D23, A18=$A18, D8=$D8, D10=$D10, D14=$D14, D21=$D21, A16=$A16, A17=$A17, D3=$D3, D24=$D24');

                  loopI:
                  for (var d
                      in digits.where((element) => !used.contains(element))) {
                    I = d;
                    var A3 = I + S;
                    var A13 = RR * I;
                    var D13 = H * I;
                    if (A3 < 1) continue;
                    if (A3 >= A5) {
                      undo();
                      continue loopT;
                    }
                    if (A13 <= A11) continue;
                    if (A13 >= A16) {
                      undo();
                      continue loopT;
                    }
                    if (D13 <= D10) continue;
                    if (D13 >= D14) {
                      undo();
                      continue loopT;
                    }
                    used.add(d);
                    trace.add('I=$I');
                    // print('$trace');
                    //
                    print(
                        'D20=$D20, A5=$A5, A7=$A7, A20=$A20, A2=$A2, A11=$A11, A23=$A23, D15=$D15, A6=$A6, A10=$A10, D1=$D1, D7=$D7, D17=$D17, D23=$D23, A18=$A18, D8=$D8, D10=$D10, D14=$D14, D21=$D21, A16=$A16, A17=$A17, D3=$D3, D24=$D24, A3=$A3, A13=$A13, D13=$D13');
                    loopG:
                    for (var d
                        in digits.where((element) => !used.contains(element))) {
                      G = d;
                      var A14 = G + I;
                      var A15 = G + O;
                      if (A14 <= A13) continue;
                      if (A14 >= A15) continue;
                      if (A14 >= A16) {
                        undo();
                        continue loopI;
                      }
                      if (A15 <= A14) continue;
                      if (A15 >= A16) {
                        undo();
                        continue loopI;
                      }
                      used.add(d);
                      trace.add('G=$G');
                      // print('$trace');
                      //
                      print(
                          'D20=$D20, A5=$A5, A7=$A7, A20=$A20, A2=$A2, A11=$A11, A23=$A23, D15=$D15, A6=$A6, A10=$A10, D1=$D1, D7=$D7, D17=$D17, D23=$D23, A18=$A18, D8=$D8, D10=$D10, D14=$D14, D21=$D21, A16=$A16, A17=$A17, D3=$D3, D24=$D24, A3=$A3, A13=$A13, D13=$D13, A14=$A14, A15=$A15');
                      loopA:
                      for (var d in digits
                          .where((element) => !used.contains(element))) {
                        A = d;
                        var A12 = A * S;
                        var D16 = A + S;
                        if (A12 <= A11) continue;
                        if (A12 >= A13) {
                          undo();
                          continue loopG;
                        }
                        if (D16 <= D15) continue;
                        if (D16 >= D17) {
                          undo();
                          continue loopG;
                        }
                        used.add(d);
                        trace.add('A=$A');
                        // print('$trace');
                        //
                        print(
                            'D20=$D20, A5=$A5, A7=$A7, A20=$A20, A2=$A2, A11=$A11, A23=$A23, D15=$D15, A6=$A6, A10=$A10, D1=$D1, D7=$D7, D17=$D17, D23=$D23, A18=$A18, D8=$D8, D10=$D10, D14=$D14, D21=$D21, A16=$A16, A17=$A17, D3=$D3, D24=$D24, A3=$A3, A13=$A13, D13=$D13, A14=$A14, A15=$A15, A12=$A12, D16=$D16');
                        loopN:
                        for (var d in digits
                            .where((element) => !used.contains(element))) {
                          N = d;
                          var A8 = A - N;
                          var D4 = S + I - N;
                          var D12 = O + N;
                          var D19 = A + N;
                          if (A8 <= A7) continue;
                          if (A8 >= A10) continue;
                          if (D4 <= D3) continue;
                          if (D4 >= D7) continue;
                          if (D12 <= D10) continue;
                          if (D12 >= D13) {
                            undo();
                            continue loopA;
                          }
                          if (D19 <= D17) continue;
                          if (D19 >= D20) {
                            undo();
                            continue loopA;
                          }
                          used.add(d);
                          trace.add('N=$N');
                          // print('$trace');
                          //
                          print(
                              'D20=$D20, A5=$A5, A7=$A7, A20=$A20, A2=$A2, A11=$A11, A23=$A23, D15=$D15, A6=$A6, A10=$A10, D1=$D1, D7=$D7, D17=$D17, D23=$D23, A18=$A18, D8=$D8, D10=$D10, D14=$D14, D21=$D21, A16=$A16, A17=$A17, D3=$D3, D24=$D24, A3=$A3, A13=$A13, D13=$D13, A14=$A14, A15=$A15, A12=$A12, D16=$D16, A8=$A8, D4=$D4, D12=$D12, D19=$D19');
                          loopM:
                          for (var d in digits
                              .where((element) => !used.contains(element))) {
                            M = d;
                            var D6 = A - M;
                            var D18 = M + O;
                            if (D6 <= D3) continue;
                            if (D6 >= D7) continue;
                            if (D18 <= D17) continue;
                            if (D18 >= D19) {
                              undo();
                              continue loopN;
                            }
                            used.add(d);
                            trace.add('M=$M');
                            // print('$trace');
                            //
                            print(
                                'D20=$D20, A5=$A5, A7=$A7, A20=$A20, A2=$A2, A11=$A11, A23=$A23, D15=$D15, A6=$A6, A10=$A10, D1=$D1, D7=$D7, D17=$D17, D23=$D23, A18=$A18, D8=$D8, D10=$D10, D14=$D14, D21=$D21, A16=$A16, A17=$A17, D3=$D3, D24=$D24, A3=$A3, A13=$A13, D13=$D13, A14=$A14, A15=$A15, A12=$A12, D16=$D16, A8=$A8, D4=$D4, D12=$D12, D19=$D19, D6=$D6, D18=$D18');
                            loopP:
                            for (var d in digits
                                .where((element) => !used.contains(element))) {
                              P = d;
                              var A4 = P - O;
                              var D22 = P + O;
                              if (A4 <= A3) continue;
                              if (A4 >= A5) {
                                undo();
                                continue loopM;
                              }
                              if (D22 <= D21) continue;
                              if (D22 >= D23) {
                                undo();
                                continue loopM;
                              }
                              used.add(d);
                              trace.add('P=$P');
                              // print('$trace');
                              //
                              print(
                                  'D20=$D20, A5=$A5, A7=$A7, A20=$A20, A2=$A2, A11=$A11, A23=$A23, D15=$D15, A6=$A6, A10=$A10, D1=$D1, D7=$D7, D17=$D17, D23=$D23, A18=$A18, D8=$D8, D10=$D10, D14=$D14, D21=$D21, A16=$A16, A17=$A17, D3=$D3, D24=$D24, A3=$A3, A13=$A13, D13=$D13, A14=$A14, A15=$A15, A12=$A12, D16=$D16, A8=$A8, D4=$D4, D12=$D12, D19=$D19, D6=$D6, D18=$D18, A4=$A4, D22=$D22');
                              loopK:
                              for (var d in digits.where(
                                  (element) => !used.contains(element))) {
                                K = d;
                                var A21 = RR * I + S * K;
                                var D11 = A + RR - K;
                                if (A21 <= A20) continue;
                                if (A21 >= A23) {
                                  undo();
                                  continue loopP;
                                }
                                if (D11 <= D10) continue;
                                if (D11 >= D12) continue;
                                used.add(d);
                                trace.add('K=$K');
                                // print('$trace');
                                //
                                print(
                                    'D20=$D20, A5=$A5, A7=$A7, A20=$A20, A2=$A2, A11=$A11, A23=$A23, D15=$D15, A6=$A6, A10=$A10, D1=$D1, D7=$D7, D17=$D17, D23=$D23, A18=$A18, D8=$D8, D10=$D10, D14=$D14, D21=$D21, A16=$A16, A17=$A17, D3=$D3, D24=$D24, A3=$A3, A13=$A13, D13=$D13, A14=$A14, A15=$A15, A12=$A12, D16=$D16, A8=$A8, D4=$D4, D12=$D12, D19=$D19, D6=$D6, D18=$D18, A4=$A4, D22=$D22, A21=$A21, D11=$D11');
                                loopL:
                                for (var d in digits.where(
                                    (element) => !used.contains(element))) {
                                  L = d;
                                  var A19 = H + A + L;
                                  if (A19 <= A18) continue;
                                  if (A19 >= A20) {
                                    undo();
                                    continue loopK;
                                  }
                                  used.add(d);
                                  trace.add('L=$L');
                                  // print('$trace');
                                  //
                                  print(
                                      'D20=$D20, A5=$A5, A7=$A7, A20=$A20, A2=$A2, A11=$A11, A23=$A23, D15=$D15, A6=$A6, A10=$A10, D1=$D1, D7=$D7, D17=$D17, D23=$D23, A18=$A18, D8=$D8, D10=$D10, D14=$D14, D21=$D21, A16=$A16, A17=$A17, D3=$D3, D24=$D24, A3=$A3, A13=$A13, D13=$D13, A14=$A14, A15=$A15, A12=$A12, D16=$D16, A8=$A8, D4=$D4, D12=$D12, D19=$D19, D6=$D6, D18=$D18, A4=$A4, D22=$D22, A21=$A21, D11=$D11, A19=$A19');
                                  loopCC:
                                  for (var d in digits.where(
                                      (element) => !used.contains(element))) {
                                    CC = d;
                                    var A9 = S + I + CC;
                                    var D9 = CC + O - L;
                                    if (A9 <= A8) continue;
                                    if (A9 >= A10) {
                                      undo();
                                      continue loopL;
                                    }
                                    if (D9 <= D8) continue;
                                    if (D9 >= D10) {
                                      undo();
                                      continue loopL;
                                    }
                                    used.add(d);
                                    trace.add('CC=$CC');
                                    // print('$trace');
                                    //
                                    print(
                                        'D20=$D20, A5=$A5, A7=$A7, A20=$A20, A2=$A2, A11=$A11, A23=$A23, D15=$D15, A6=$A6, A10=$A10, D1=$D1, D7=$D7, D17=$D17, D23=$D23, A18=$A18, D8=$D8, D10=$D10, D14=$D14, D21=$D21, A16=$A16, A17=$A17, D3=$D3, D24=$D24, A3=$A3, A13=$A13, D13=$D13, A14=$A14, A15=$A15, A12=$A12, D16=$D16, A8=$A8, D4=$D4, D12=$D12, D19=$D19, D6=$D6, D18=$D18, A4=$A4, D22=$D22, A21=$A21, D11=$D11, A19=$A19, A9=$A9, D9=$D9');
                                    loopD:
                                    for (var d in digits.where(
                                        (element) => !used.contains(element))) {
                                      D = d;
                                      var D2 = D - O;
                                      if (D2 <= D1) continue;
                                      if (D2 >= D3) {
                                        undo();
                                        continue loopCC;
                                      }
                                      used.add(d);
                                      trace.add('D=$D');
                                      // print('$trace');
                                      loopB:
                                      for (var d in digits.where((element) =>
                                          !used.contains(element))) {
                                        B = d;
                                        var D5 = CC + O - B;
                                        if (D5 <= D4) continue;
                                        if (D5 >= D6) continue;
                                        used.add(d);
                                        trace.add('B=$B');
                                        // print('$trace');
                                        loopF:
                                        for (var d in digits.where((element) =>
                                            !used.contains(element))) {
                                          F = d;
                                          var A22 = F + O + B;
                                          if (A22 <= A20) continue;
                                          if (A22 >= A23) {
                                            undo();
                                            continue loopB;
                                          }
                                          used.add(d);
                                          trace.add('F=$F');
                                          // print('$trace');
                                          loopW:
                                          for (var d in digits.where(
                                              (element) =>
                                                  !used.contains(element))) {
                                            W = d;
                                            var A1 = H + A - W;
                                            if (A1 < 1) continue;
                                            if (A1 > A2) continue;
                                            used.add(d);
                                            trace.add('W=$W');
                                            print('$trace');
                                            undo();
                                          }
                                          undo();
                                        }
                                        undo();
                                      }
                                      undo();
                                    }
                                    undo();
                                  }
                                  undo();
                                }
                                undo();
                              }
                              undo();
                            }
                            undo();
                          }
                          undo();
                        }
                        undo();
                      }
                      undo();
                    }
                    undo();
                  }
                  undo();
                }
                undo();
              }
              undo();
            }
            undo();
          }
          undo();
        }
        undo();
      }
      undo();
    }
    undo();
  }
}
