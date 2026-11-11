# Ticket 2 — Office hardware specification

## 1. What was asked
"We are opening the second office and need four computers — accountant, sales, web developer, designer. Budget 3,000,000 tenge for everything. Everyone says we should just buy the same four machines, is that right? Make sure they last a few years. Monitors included."

## 2. What was actually needed
**Where the request is wrong:** The director's assumption that four identical machines should be purchased is incorrect. Each of the four roles (accountant, sales, web developer, designer) has a profoundly different workload that creates a different hardware bottleneck. Buying identical machines would result in misallocated funds, leaving the designer with poor graphics performance and the sales manager with inadequate memory for heavy multitasking.

**What the request left out:** The request specified a 3,000,000 KZT budget for computers and monitors, but it entirely left out operating system licenses, which are legally required for corporate use. It also omitted details regarding basic peripheral devices (keyboards, mice, network cables). Furthermore, the instruction "last a few years" lacks a precise timeframe, and the request fails to consider the software constraints of each user. Finally, the requester (Daniyar, the Director) is looking at this from a business and budget perspective; the hardware choices must be justified through ROI and productivity, not just tech specs.

**What I would ask Daniyar:**
- Which specific software packages will each role utilize (e.g., Adobe Creative Suite for the designer, local Docker containers for the web developer)?
- Does the 3,000,000 KZT budget need to cover keyboards, mice, and network cables, or are those funded separately from a general office supplies budget?
- What is the exact expected lifespan of these machines (e.g., 3 years vs. 5 years) to accurately plan for future upgrades?

**What I assumed instead:**
- The budget must cover licensed operating systems, meeting the hard requirement for corporate compliance. Windows 11 Pro is assumed mandatory for the accountant and standard staff, while free Ubuntu Linux is assumed both legally and technically optimal for the web developer.
- Keyboards, mice, and cables are handled by a separate office supplies budget, enabling the full 3,000,000 KZT to be allocated strictly to the systems, monitors, and OS licenses.
- Every machine must have at least 16 GB of memory and a 1 TB SSD to meet modern baseline standards.
- To ensure the machines "last a few years" (assuming a 3-5 year lifespan), the budget allocation will prioritize solving core bottlenecks today (like 32 GB RAM or strong GPUs) on mature platforms (AM4/LGA1700) rather than overpaying for the absolute newest motherboard sockets.

## 3. What I did
How I went from roles to loads to parts: I analyzed each role's daily workload to identify the core hardware bottleneck. I then allocated the 3,000,000 KZT budget asymmetrically so that money went directly to the bottleneck of each user. All configurations meet the hard requirements: a minimum of 16 GB RAM, a 1 TB NVMe SSD, a licensed operating system, and a monitor.

The budget: The full explanation and components are in `builds.md`, and the exact pricing from Kazakhstani vendors (Kaspi.kz, DNS, Forcecom) is detailed in `budget.csv`. Total spending is 2,146,615 KZT, successfully keeping the company well under the 3,000,000 KZT limit and saving 853,385 tenge.

**Answers to the Director's Questions:**

1. **Which machine to upgrade first:** The Web Developer's machine will need an upgrade first, specifically swapping the 32 GB of RAM for 64 GB, and potentially adding a second NVMe SSD. Local Docker containers and virtual machines scale exponentially; within 18 months, running multiple local microservices and databases concurrently will likely saturate the initial 32 GB of memory and 1 TB of storage.

2. **Pre-built vs. Custom:** If we purchased equivalent pre-built workstations, the company gains a unified enterprise warranty, a single point of contact for support, and saves assembly time. However, we lose significantly on the upgrade path, component quality, and price. Pre-builts often utilize proprietary cases and motherboards that prevent future upgrades, and they frequently mix poor-quality parts (like a tiny 512GB SSD with a slow HDD for a designer) to artificially lower costs. 

| Role | Pre-built Equivalent | Estimated Price (KZT) | Vendor | Date |
| :--- | :--- | :--- | :--- | :--- |
| Accountant | HP System Unit (i5-14400 / 16GB / 1TB SSD / Win 11 Pro) | ~644,440 | [Kaspi.kz](https://kaspi.kz/shop/p/hp-b6zd2et-chernyi-161092399/?c=750000000) | 2026-11-10 |
| Sales Manager | Tehnicom (Ryzen 3 3200G / 32GB / 1TB SSD + 4TB HDD) | ~379,730 | [Kaspi.kz](https://kaspi.kz/shop/p/tehnicom-art51080-belyi-171143183/?c=750000000) | 2026-11-10 |
| Web Developer | Q7 Gigabyte (i5-12400 / 32GB / 1TB SSD / Win 11) | ~306,693 | [Kaspi.kz](https://satu.kz/p130538752-kompyuter-intel-core.html) | 2026-11-10 |
| Designer | Tehnicom (i7-12700F / RTX 4060 / 32GB / 512GB SSD + 2TB HDD) | ~766,189 | [Kaspi.kz](https://kaspi.kz/shop/p/tehnicom-i712700f00739-belyi-182714537/?c=750000000) | 2026-11-10 |

3. **Who will complain first:** The Accountant will complain within the first month, specifically about available screen space. While the CPU and NVMe SSD process local databases extremely quickly, accounting requires viewing multiple large Excel sheets, banking clients, and 1C simultaneously. A single 23.8-inch monitor forces frequent tab-switching and window resizing, which becomes a workflow bottleneck despite the fast hardware.

## 4. Evidence
- `evidence/pcpartpicker-links.md` — contains PCPartPicker lists verifying CPU socket, RAM type, M.2 slot, and power wattage compatibility for all four builds. (Note: PCPartPicker is used exclusively for compatibility checks, not pricing).
- `evidence/vendor-quotes/` — contains dated screenshots from Kazakhstani vendors with the URL and system date visible, proving the parts are available in Kazakhstan at the listed prices.

## 5. What I would do differently
Instead of relying strictly on a separate generic office supply budget for peripherals, I would explicitly allocate funds from the remaining 853,385 KZT to buy a high-precision ergonomic mouse (like the Logitech MX Master 3S) for the Designer. Standard office mice cause wrist strain during long sessions and lack the tracking accuracy required for Adobe Creative Cloud work.
