### Build 1 — Accountant
**Load:** 1C Enterprise accounting software, multiple large Excel spreadsheets, and banking client apps open simultaneously for 8 hours a day. 
**Bottleneck:** CPU single-core performance and storage speed. Complex Excel calculations and local 1C database queries require strong single-thread CPU processing, and waiting for large databases to load causes significant workflow lag. 
**Trade-off:** Skipped a dedicated GPU since accounting software relies purely on 2D rendering. Diverted those funds into an AMD Ryzen 5 5600G APU (a strong multi-core processor with integrated graphics), a fast 1 TB NVMe SSD for instant database access, and an active Windows 11 Pro license, which is strictly required for Kazakhstan's accounting and banking software infrastructure. The baseline 16 GB of RAM is sufficient to keep these specific applications running smoothly without overspending.
**Total:** 467,386 KZT (budget.csv, rows 2-10)

### Build 2 — Sales Manager
**Load:** CRM in a browser, 30–40 tabs, Excel, and four hours of video calls a day, sometimes all at once. 
**Bottleneck:** Memory, not CPU. Chrome with forty tabs plus an active video call consumes around 11–12 GB of RAM. On a standard 8 GB or 16 GB machine, it risks swapping and hard freezing in the middle of a customer call. 
**Trade-off:** Took a basic entry-level CPU (Ryzen 3 3200G) instead of a premium one and spent the saved money on upgrading to 32 GB of RAM instead of the baseline 16 GB. Integrated graphics and 4 cores are more than enough to display a CRM, but running out of memory during a sales call is a critical failure. 
**Total:** 454,662 KZT (budget.csv, rows 11-19)

### Build 3 — Web Developer
**Load:** IDE (VS Code / PyCharm), running local Docker containers, local databases, and multiple browsers with developer tools open concurrently. 
**Bottleneck:** Memory and CPU threads. Docker containers and virtual machines reserve a lot of memory immediately, while compiling code or running local servers utilizes multi-threading heavily. 
**Trade-off:** Chose a Linux operating system (Ubuntu) because it is free, fully licensed for corporate use, and native for web development tools. Used those OS savings to invest in a capable multi-core CPU (Intel Core i5 12400 with 6 cores and 12 threads) and 32 GB of RAM. Skipped a dedicated GPU entirely since web development is heavily CPU and RAM bound. I also selected a standard 23.8" monitor to ensure the budget is preserved for the 1 TB NVMe SSD and high RAM capacity.
**Total:** 479,668 KZT (budget.csv, rows 20-28)

### Build 4 — Designer
**Load:** Adobe Creative Cloud (Illustrator, Photoshop, Premiere Pro), rendering video projects, and managing heavy graphic assets. 
**Bottleneck:** GPU VRAM, System RAM, and the Monitor. Rendering large files requires hardware acceleration via a dedicated GPU. Additionally, the monitor must have strict color accuracy to ensure client work looks correct. 
**Trade-off:** Spent a massive portion of the overall budget on a dedicated NVIDIA RTX 3060 12GB GPU (crucial for Adobe VRAM caching) and a quality 27-inch MSI PRO monitor. To stay well under the 3,000,000 KZT limit, I accepted a slightly older, but still highly capable 8-core AM4 CPU platform (Ryzen 7 5700X) instead of the latest AM5 socket. In Adobe applications, the GPU and the 32 GB of RAM handle the heaviest work, making this a smart sacrifice. It was also essential to include a 1 TB SSD for storing video projects, and Windows 11 Pro for full compatibility with the Adobe Creative Cloud suite.   
**Total:** 744,899 KZT (budget.csv, rows 29-38)
