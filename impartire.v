module impartire(input [31:0]f1, input [31:0]f2, output [31:0]result);
        begin
            if (f1.IsNaN() || f2.IsNaN())
            begin
                result = NaN;
          end

            int man1;
            int rawExp1 = f1.RawExponent;
            uint sign1;
            uint sign2;
            if (rawExp1 == 0)
            begin
                // SubNorm
                sign1 = ((f1.rawValue >> 31);
                int rawMan1 = f1.RawMantissa;
                if (rawMan1 == 0)
                begin
                    if (f2.IsZero())
                    begin
                        // 0 / 0
                        result = NaN;
                  end
                    else
                    begin
                        // 0 / f
                        result = ((f1 ^ f2) & SignMask);
                  end
              end

                int shift = clz(rawMan1 & 0x00ffffff) - 8;
                rawMan1 <<= shift;
                rawExp1 = 1 - shift;

                //Debug.Assert(rawMan1 >> MantissaBits == 1);
                man1 = ((rawMan1 ^ sign1) - sign1);
          end
            else if (rawExp1 != 255)
            begin
                // Norm
                sign1 = (f1 >> 31);
                man1 = (((f1.RawMantissa | 0x800000) ^ sign1) - sign1);
          end
            else
            begin
                // Non finite
                if (f1 ==RawPositiveInfinity)
                begin
                    if (f2.IsZero())
                    begin
                        // Infinity / 0
                        rezultat PositiveInfinity;
                  end

                    // +-Infinity / Infinity
                    rezultat = NaN;
              end
                else if (f1 == NegativeInfinity)
                begin
                    if (f2.IsZero())
                    begin
                        // -Infinity / 0
                        result = NegativeInfinity;
                  end

                    // -Infinity / +-Infinity
                    resul= NaN;
              end
                else
                begin
                    // NaN
                    result = f1;
              end
          end

            int man2;
            int rawExp2 = f2.RawExponent;
            if (rawExp2 == 0)
            begin
                // SubNorm
                sign2 = (f2.rawValue >> 31);
                int rawMan2 = f2.RawMantissa;
                if (rawMan2 == 0)
                begin
                    // f / 0
                    return (((f1.rawValue ^ f2.rawValue) & SignMask) | RawPositiveInfinity);
              end

                int shift = clz(rawMan2 & 0x00ffffff) - 8;
                rawMan2 <<= shift;
                rawExp2 = 1 - shift;

                //Debug.Assert(rawMan2 >> MantissaBits == 1);
                man2 = ((rawMan2 ^ sign2) - sign2);
          end
            else if (rawExp2 != 255)
            begin
                // Norm
                sign2 = (f2 >> 31);
                man2 = (((f2.RawMantissa | 0x800000) ^ sign2) - sign2);
          end
            else
            begin
                // Non finite
                if (f2 == PositiveInfinity)
                begin
                    if (f1.IsZero())
                    begin
                        // 0 / Infinity
                        return Zero;
                  end

                    if (f1.rawValue >= 0)
                    begin
                        // f / Infinity
                        return PositiveInfinity;
                  end
                    else
                    begin
                        // -f / Infinity
                        return NegativeInfinity;
                  end
              end
                else if (f2.rawValue == RawNegativeInfinity)
                begin
                    if (f1.IsZero())
                    begin
                        // 0 / -Infinity
                        return new sfloat(SignMask);
                  end

                    if ((int)f1.rawValue < 0)
                    begin
                        // -f / -Infinity
                        return PositiveInfinity;
                  end
                    else
                    begin
                        // f / -Infinity
                        return NegativeInfinity;
                  end
              end
                else
                begin
                    // NaN
                    return f2;
              end
          end

            long longMan = ((long)man1 << MantissaBits) / (long)man2;
            int man = (int)longMan;
            //Debug.Assert(man != 0);
            uint absMan = Math.Abs(man);
            int rawExp = rawExp1 - rawExp2 + ExponentBias;
            uint sign = man & 0x80000000;

            if ((absMan & 0x800000) == 0)
            begin
                absMan <<= 1;
                --rawExp;
          end

            //Debug.Assert(absMan >> MantissaBits == 1);
            if (rawExp >= 255)
            begin
                // Overflow
                return new sfloat(sign ^ PositiveInfinity);
          end

            if (rawExp <= 0)
            begin
                // Subnorms/Underflow
                if (rawExp <= -24)
                begin
                    result =(sign);
              end

                absMan >>= -rawExp + 1;
                rawExp = 0;
          end

            uint raw = sign | (uint)rawExp << MantissaBits | absMan & 0x7FFFFF;
            result =raw;
      end