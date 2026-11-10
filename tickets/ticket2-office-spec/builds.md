### Build 1 — Accountant
**Load:** 1C Enterprise accounting software, multiple large Excel spreadsheets, banking client apps open simultaneously for 8 hours a day.
**Bottleneck:** CPU single-core performance and storage speed. Complex Excel calculations and local 1C database queries require strong single-thread CPU processing. Furthermore, waiting for large databases to load.
**Trade-off:** Skipped a dedicated GPU since accounting software relies on 2D rendering and CPU processing. Diverted those funds into a much sophisticated SSD for instant database access and an active Windows 11 Pro license, which is required for Kazakhstan's accounting and banking software infrastructure. 
**Total:** [WILL BE CALCULATED LATER] KZT (budget.csv, rows X-Y)

### Build 2 — Sales Manager
**Load:** CRM in a browser, 30–40 tabs, Excel, four hours of video calls a day, sometimes all at once.
**Bottleneck:** Memory, not CPU. Chrome with forty tabs plus a video call is around 11–12 GB. On 8 GB the machine starts lagging in the middle of a customer call.
**Trade-off:** Took a standard mid-range CPU instead of the best one and spent the saved money on 32 GB of RAM instead of the baseline 16 GB. Integrated graphics are more than enough for a monitor displaying a CRM.
**Total:** [WILL BE CALCULATED LATER] KZT (budget.csv, rows X-Y)

### Build 3 — Web Developer
**Load:** IDE (VS Code / PyCharm), running local Docker containers, a local database, and multiple browsers with developer tools open concurrently.
**Bottleneck:** Memory and CPU threads. Docker containers and virtual machines reserve a lot of memory immediately, while compiling code or running servers utilizes multi-threading.
**Trade-off:** Chose a Linux operating system (Ubuntu) because it is free, fully licensed for corporate use, and native for web development tools. Used those savings to invest in a higher core-count CPU and 32 GB of RAM. Skipped a dedicated GPU since web development is CPU and RAM bound.
**Total:** [WILL BE CALCULATED LATER] KZT (budget.csv, rows X-Y)

### Build 4 — Designer
**Load:** Adobe Creative Cloud (Illustrator, Photoshop, Premiere Pro), rendering video projects.
**Bottleneck:** GPU VRAM, System RAM, and the Monitor. Rendering large files require hardware acceleration via a dedicated GPU. Additionally, the monitor must have strict color accuracy to ensure client work looks correct.
**Trade-off:** Spent a massive portion of the overall company budget on a dedicated NVIDIA GPU and a high-color-accuracy monitor. To stay under the 3,000,000 KZT limit, I accepted a slightly older (but still highly capable) CPU platform. In Adobe applications, the GPU handles the heaviest work, making this a good sacrifice.
**Total:** [WILL BE CALCULATED LATER] KZT (budget.csv, rows X-Y)
