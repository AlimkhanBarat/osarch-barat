# Ticket 2 — Office hardware specification

## 1. What was asked

"We are opening the second office and need four computers — accountant, sales, web developer, designer. Budget 3,000,000 tenge for everything. Everyone says we should just buy the same four machines, is that right? Make sure they last a few years. Monitors included."

## 2. What was actually needed

Where the request is wrong: The director's assumption that four identical machines should be purchased is incorrect. Each of the four roles (accountant, sales, web developer, designer) has a different workload that creates a different hardware bottleneck. Buying identical machines would result in misallocated funds, leaving the designer with poor graphics performance and the sales manager with inadequate memory for heavy tasks.

What the request left out: The request specified a 3,000,000 KZT budget for computers and monitors, but it left out several critical components. It did not account for operating system licenses, which are legally required for office use. It also omitted details regarding basic peripheral devices (keyboards, mice) and the specific software each employee needs. Furthermore, the instruction "last a few years" is vague and lacked a precise timeframe, which is necessary for choosing the appropriate memory generation for future upgrades.

If I could ask Daniyar, I would ask:
* Which specific software packages will each role utilize (e.g Adobe Creative Suite for the designer, local containers for the web developer)?
* Does the 3,000,000 KZT budget need to cover keyboards, mice, and other peripherals, or are those funded separately?
* What is the exact expected lifespan of these machines ?

What I assumed:
* The budget must cover licensed operating systems, meeting the hard requirement for launch. Windows is for accountants and standard office staff. Linux is an option for web developers if it fits the project.
* Keyboards, mice, and network cables are handled by a separate office supplies budget, enabling the full 3,000,000 KZT to be allocated to the system components, monitors, and OS licenses.
* Every machine must have at least 16 GB of memory and a 1 TB SSD.
* To ensure the machines "last a few years," the budget allocation will prioritize modern platforms where possible, ensuring that components like the CPU or memory can be upgraded in the future without requiring a full motherboard replacement.


> This section carries 6 of the 20 marks and is the one most often left empty.

## 3. What I did

How I went from roles to loads to parts: I analyzed each role's daily workload to identify the hardware bottleneck (CPU single-core performance vs. multi-threading, RAM capacity). I then allocated the 3,000,000 KZT budget asymmetrically. All configurations meet the hard requirements: a minimum of 16 GB RAM, a 1 TB SSD, a licensed operating system, and a monitor. 

The budget: The full reasoning and components are in [builds.md](builds.md), and the exact pricing from a Kazakhstani vendor (White Wind / shop.kz) is detailed in [budget.csv](budget.csv). Total spending came to exactly 2,099,000 KZT, saving the company almost 1 million tenge.

**Answers to the Director's Questions:**
1. **Which machine to upgrade first:** The Web Developer's machine will need an upgrade first, specifically a second SSD and potentially a jump to 64 GB of RAM. Local Docker containers, virtual machines, and node_modules scale not linearly, but exponentially. Within 18 months, the 1 TB drive will likely fill up, and running multiple local services will utilize the initial 32 GB of memory.
2. **Pre-built vs. Custom:** If we purchased equivalent pre-built workstations, the company gains a unified enterprise warranty (next-business-day repair) and zero assembly time. However, we lose significantly on the upgrade path and price. Pre-builts utilize proprietary motherboards and weak power supplies, meaning we cannot just change GPU for a better one for the designer. Later, we would have to buy a whole new PC which is also costly. 
3. **Who will complain first:** The Accountant will complain within the first month, specifically about available screen area. While the CPU and SSD are processing databases really quickly, accounting requires multiple large Excel sheets, banking clients, and 1C simultaneously. A single 24-inch monitor forces constant switching tabs, which becomes a workflow bottleneck despite the fast hardware.

## 4. Evidence
- `evidence/pcpartpicker-links.md` — contains PCPartPicker lists verifying socket, RAM, and power compatibility for all four builds.
- `evidence/vendor-quotes/` — contains screenshots from shop.kz with the URL and system date visible, proving the parts are available in Kazakhstan at the listed prices.

## 5. What I would do differently
Instead of relying strictly on a separate generic office supply budget for peripherals, I would explicitly carve out funds from the 3,000,000 KZT to buy an ergonomic, high-precision mouse (like the Logitech MX Master 3S) for the Designer. Standard cheap office mice cause wrist strain during 8-hour Adobe Illustrator sessions and lack the tracking accuracy required for design work.

## 4. Evidence

## 5. What I would do differently

At least one thing. "Nothing, it all went well" is not an answer.
