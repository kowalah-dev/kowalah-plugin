# Listing screenshots

Partner Center wants three to five screenshots, 1366 x 768 PNG, under 1,024 KB,
each with a caption, and at least one showing Kowalah inside Microsoft 365
Copilot. Microsoft allows framing and marketing text, but the product UI in
them must be real.

`frame.html` puts a real capture in a branded frame with its caption.
`build.sh` renders all five to `out/screenshot-N.png`. A missing capture
renders as a placeholder that says what to capture.

## Taking the captures

1. Use the reviewer demo organisation, never a real client's or Kowalah's own
   data. The listing is public.
2. Size the Chrome window to 1280 x 800 (16:10, the slot's shape) and zoom the
   page to 110-125% so text stays readable after scaling to 900 px wide.
3. Save each window capture as `captures/shot-N.png`:

   | N | Surface | Capture |
   |---|---|---|
   | 1 | Copilot Chat | The Kowalah agent with its conversation starters |
   | 2 | Copilot Chat | "Walk me through our slowest process. Where does the time actually go?" |
   | 3 | Copilot Chat | "How is our AI programme going against our vision?" |
   | 4 | Copilot Cowork | A Kowalah skill at work: programme review or process redesign |
   | 5 | Copilot Chat | Recording an outcome, at the confirmation step |

4. Run `./build.sh` and upload `out/screenshot-1.png` to `screenshot-5.png`.

Captions live in `frame.html`. Keep them short and plain: Microsoft's
validation flags superlatives and marketing claims.

`captures/` and `out/` are gitignored: captures show demo data, and the output
is rebuilt from them.
