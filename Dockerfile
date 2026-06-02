FROM kalilinux/kali-rolling

ENV DEBIAN_FRONTEND=noninteractive

# Base dependencies
RUN apt-get update && apt-get install -y \
    python3 python3-venv python3-pip \
    git curl jq wget build-essential \
    golang \
    && rm -rf /var/lib/apt/lists/*

# Essential tools
RUN apt-get update && apt-get install -y \
    nmap nikto sqlmap gobuster ffuf \
    hydra john hashcat \
    dirb masscan nbtscan arp-scan \
    && rm -rf /var/lib/apt/lists/*

    # Network/SMB tools
RUN apt-get update && apt-get install -y \
    smbmap enum4linux \
    samba-common-bin \
    netcat-openbsd tcpdump wireshark-common tshark \
    responder \
    && rm -rf /var/lib/apt/lists/*
# Web tools
RUN apt-get update && apt-get install -y \
    wfuzz wafw00f dirsearch \
    feroxbuster wpscan \
    medusa patator \
    && rm -rf /var/lib/apt/lists/*

# Recon/OSINT
RUN apt-get update && apt-get install -y \
    amass fierce dnsenum \
    theharvester recon-ng \
    exiftool binwalk foremost \
    steghide  \
    && rm -rf /var/lib/apt/lists/*

# Binary/exploitation
RUN apt-get update && apt-get install -y \
    gdb radare2 checksec \
    xxd file testdisk \
    metasploit-framework \
    exploitdb \
    && rm -rf /var/lib/apt/lists/*

    # Forensics
RUN apt-get update && apt-get install -y \
    scalpel bulk-extractor \
    aircrack-ng \
    && rm -rf /var/lib/apt/lists/*

# Volatility3 via pip
RUN pip3 install --break-system-packages volatility3

# Go-based ProjectDiscovery tools
RUN go install github.com/projectdiscovery/httpx/cmd/httpx@latest && \
    go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest && \
    go install github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest && \
    go install github.com/projectdiscovery/katana/cmd/katana@latest && \
    go install github.com/hahwul/dalfox/v2@latest && \
    go install github.com/hakluke/hakrawler@latest && \
    go install github.com/lc/gau/v2/cmd/gau@latest && \
    go install github.com/tomnomnom/waybackurls@latest && \
    go install github.com/tomnomnom/anew@latest && \
    go install github.com/tomnomnom/qsreplace@latest && \
    go install github.com/ffuf/ffuf/v2@latest && \
    go install github.com/OJ/gobuster/v3@latest

ENV PATH="/root/go/bin:$PATH"

# Python-based tools
RUN pip3 install --break-system-packages \
    arjun \
    wafw00f \
    sherlock-project \
    shodan \
    censys \
    impacket \
    uro \
    volatility3

WORKDIR /opt

RUN git clone https://github.com/Yenn503/villager-ai-hexstrike-integration.git
RUN cd villager-ai-hexstrike-integration && \
    python3 -m venv villager-venv-new && \
    villager-venv-new/bin/pip install --upgrade pip && \
    villager-venv-new/bin/pip install -r requirements.txt && \
    mkdir -p logs

RUN git clone https://github.com/0x4m4/hexstrike-ai.git
RUN cd hexstrike-ai && \
    python3 -m venv .venv && \
    .venv/bin/pip install --upgrade pip && \
    .venv/bin/pip install -r requirements.txt

# Symlinks for tools with different binary names
RUN ln -sf /usr/bin/msfconsole /usr/local/bin/metasploit 2>/dev/null || true && \
    ln -sf $(which searchsploit) /usr/local/bin/exploit-db 2>/dev/null || true && \
    ln -sf $(which nxc 2>/dev/null || which crackmapexec) /usr/local/bin/nxc 2>/dev/null || true

EXPOSE 37695 8888 25989 1611 8080
