# Ticket 2 — Office hardware specification

## 1. What was asked
"We are opening the second office and need four computers — accountant, sales, web developer, designer. Budget 3,000,000 tenge for everything. Everyone says we should just buy the same four machines, is that right? Make sure they last a few years. Monitors included."

## 2. What was actually needed
Where the request is wrong: The director's assumption that four identical machines should be purchased is incorrect. Each of the four roles (accountant, sales, web developer, designer) has a profoundly different workload that creates a different hardware bottleneck. Buying identical machines would result in misallocated funds, leaving the designer with poor graphics performance and the sales manager with inadequate memory for heavy multitasking.
What the request left out: The request specified a 3,000,000 KZT budget for computers and monitors, but it entirely left out operating system licenses, which are legally required for corporate use. It also omitted details regarding basic peripheral devices (keyboards, mice) and the specific software each employee needs. Furthermore, the instruction "last a few years" is vague and lacked a precise timeframe. 
If I could ask Daniyar, I would ask:
- Which specific software packages will each role utilize (e.g., Adobe Creative Suite for the designer, local containers for the web developer)?
- Does the 3,000,000 KZT budget need to cover keyboards, mice, and network cables, or are those funded separately?
- What is the exact expected lifespan of these machines?
What I assumed:
- The budget must cover licensed operating systems, meeting the hard requirement for launch. Windows is for accountants and standard office staff. Linux is assumed suitable for the web developer.
- Keyboards, mice, and cables are handled by a separate office supplies budget, enabling the full 3,000,000 KZT to be allocated to the systems, monitors, and OS licenses.
- Every machine must have at least 16 GB of memory and a 1 TB SSD.
- To ensure the machines "last a few years," the budget allocation will prioritize core bottleneck components (like 32GB RAM or heavy GPUs) over paying a premium for the absolute newest motherboard sockets.

## 3. What I did
How I went from roles to loads to parts: I analyzed each role's daily workload to identify the hardware bottleneck. I then allocated the 3,000,000 KZT budget asymmetrically so that money went to the bottleneck of each user. All configurations meet the hard requirements: a minimum of 16 GB RAM, a 1 TB SSD, a licensed operating system, and a monitor.
The budget: The full explanation and components are in builds.md, and the exact pricing from the vendors (Kaspi.kz / DNS) is detailed in budget.csv. Total spending is 1,982,104 KZT, saving the company over 1,000,000 tenge.

Answers to the Director's Questions:
1. Which machine to upgrade first: The Web Developer's machine will need an upgrade first, specifically a second SSD and a potential swap to 64 GB of RAM. Local Docker containers, virtual machines scale exponentially. Within 18 months, the 1 TB drive will likely fill up, and running multiple local services will run out the initial 32 GB of memory.
2. Pre-built vs. Custom: 
If we purchased equivalent pre-built workstations, the company gains a unified enterprise warranty and saves assembly time. However, we lose significantly on the upgrade path and price. Pre-builts often utilize strange storage configurations (like mixing a tiny 512GB SSD with a slow HDD for the designer) and we lose an opportunity of meaningful future upgrades due to proprietary cases and motherboards. We would have to buy a whole new PC rather than just swapping a part.

| Role | Pre-built Equivalent | Estimated Price (KZT) | Vendor | Date |
| :--- | :--- | :--- | :--- | :--- |
| Accountant | HP System Unit (i5-14400 / 16GB / 1TB SSD / Win 11 Pro) | ~644,440 | [Kaspi.kz](https://kaspi.kz/shop/p/hp-b6zd2et-chernyi-161092399/?c=750000000) | 2026-11-10 |
| Sales Manager | Tehnicom (Ryzen 3 3200G / 32GB / 1TB SSD + 4TB HDD) | ~379,730 | [Kaspi.kz](https://kaspi.kz/shop/p/tehnicom-art51080-belyi-171143183/?c=750000000) | 2026-11-10 |
| Web Developer | Q7 Gigabyte (i5-12400 / 32GB / 1TB SSD / Win 11) | ~306,693 | [Kaspi.kz](https://satu.kz/p130538752-kompyuter-intel-core.html?utm_source=google_pla&utm_medium=cpc&utm_content=pla&utm_campaign=pla_cpc_tehnika_i_elektronika&gad_source=1&gad_campaignid=20830817172&gbraid=0AAAAABtAR26jiHNvJB9DGfONIDwI84kWC&gclid=Cj0KCQiAnsvXBhCqARIsAHKgGNbePBmqv-YdUL0MYEGkIVVH9nawn8HwnvjssR3G_mPvCwu2BvYuqpoaAgtPEALw_wcB) | 2026-11-10 |
| Designer | Tehnicom (i7-12700F / RTX 4060 / 32GB / 512GB SSD + 2TB HDD) | ~766,189 | [Kaspi.kz](https://kaspi.kz/shop/p/tehnicom-i712700f00739-belyi-182714537/?c=750000000) | 2026-11-10 |

3. Who will complain first: The Accountant will complain within the first month, specifically about available screen space. While the CPU and SSD process databases extremely quickly, accounting requires multiple large Excel sheets, banking clients, and 1C simultaneously. A single 23.8-inch monitor forces frequent tab switching, which becomes a workflow bottleneck despite the fast hardware.

## 4. Evidence
- evidence/pcpartpicker-links.md — contains PCPartPicker lists verifying socket, RAM type, M.2 slot, and power wattage compatibility for all four builds.
- evidence/vendor-quotes/ — contains dated screenshots from Kazakhstani vendors with the URL and system date visible, proving the parts are available in Kazakhstan at the listed prices.

## 5. What I would do differently
Instead of relying strictly on a separate generic office supply budget for peripherals, I would explicitly allocate funds from the remaining 1,000,000 KZT to buy an high-precision mouse (like the Logitech MX Master 3S) for the Designer. Standard office mice cause wrist strain during long working sessions and lack the tracking accuracy required for design work.
