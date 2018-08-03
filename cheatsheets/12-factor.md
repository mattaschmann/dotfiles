---
title: 12 Factor Apps
---

[The Twelve-Factor App][12factor]

1. **[Codebase][codebase]**
    - One codebase tracked in revision control, many deploys
    - The Version Control system manages past, present, and proposed versions as branches or tags
    - **Importance: Non-negotiable** Everyone does this, and developers will laugh at you if you aren’t.
    - Requirements:
         1. [ ] [Configs][config] are externalized
         1. [ ] One code base for an app 
            - Example: client app, api app, 2 separate apps.  Together they make a distributed system.
         1. [ ] No code is shared or [dependent][dependencies] on code from any other app.
         1. [ ] All Releases and versions are managed in code base
    - api and client app are separate "apps"
2. **[Dependencies][dependencies]**
    - Explicitly declare and isolate dependencies
    - All required dependencies either use a community package manager or are managed from source in a permissioned version control system.
    - **Importance: High** Without this, your team will have a constant slow time-suck of confusion and frustration, multiplied by their size and number of applications. Spare yourself.
    - Requirements:
        1. [ ] Dependency Declaration Manifest File
            - Dependencies and exact versions are clearly defined. (version-locking)
            - Examples: package.json, requirements.txt
        1. [ ] No System-Wide packages
            - i.e. The app does not rely on common/system-wide packages (ex. apt-get/yum)
        1. [ ] Isolated and  Contained Environment
            - i.e. The app installs within an isolated or virtualized environment where version of the code engine (python/ruby/node) are explicitly controlled/declared in addition to its required libraries/[dependencies][dependencies].
    - Assuming Requirements are met, the only requirements to run should be:
        1. Language Runtime
        1. [Dependency][dependencies] Manifest
        1. Environment [Config][config]
3. **[Config][config]**
    - Store config in the system environment
    - Config varies substantially across deploys, code does not.
    - The app stores config in environment variables that are easy to change between deploys **without changing any code**. They are never grouped together as "environments" (does not scale), but instead are independently managed for each deploy.
    - **Importance: High** You should be able to open-source your code at a moments notice.
    - Requirements:
        1. [ ] [Configuration][config] is separated from codebase
        1. [ ] [Config][config] files, values, and secrets (i.e. passwords) are NOT included in the codebase.
            - Example: dotenv file should never be committed.
        1. [ ] [Configuration][config] is managed entirely by variables that can be changed/established on build
        1. [ ] App can be made open source at any time without revealing credentials.
4. **[Backing services][backing-services]**
    - Treat backing services as attached resources
    - **Importance: High** Given the current bindings to services, there’s little reason not to adhere to this best-practice.
    - Requirements:
        1. [ ] Backing services are defined in [config][config] as a url or other protocol. (Never requires codebase changes)
    - Test:
        1. Can you interchange your local, production, or third-party services with each other?
            - Example: AWS RDS vs Postgres, SMTP server vs Mailer Service
5. **[Build, release, run][build-release-run]**
    - Strictly separate build and run stages
    - **Importance: Medium** From a practical perspective, the tools and framework you use will define best-practices for building, deploying, and running your app. Some do a better job than others of enforcing strict separation. 
    - Requirements:
        1. [ ] Build Stage: compiles everything required at a specific commit except for deploy config. Dev responsibility.
        1. [ ] Release Stage: adds env config
            - Dev responsibility: provide required config template
            - Ops responsibility: populate config variables
        1. [ ] Run Stage: App execution environment. Ops Responsibility
6. **[Processes][processes]**
    - Execute the app as one or more stateless processes
    - **Importance: High** Not only is a stateless app more robust, but it’s easier to manage, generally incurs fewer bugs, and scales better.
    - Requirements:
        1. [ ] Stateless
        1. [ ] Persistent data is stored in a stateful backing service.
            - Examples: Uploaded files, databases
        1. [ ] Memory or temp files can be used as a brief single-transaction cache.  It shall never be reused.
        1. [ ] Sessions are not managed in the app.
            - Sticky-Sessions do not scale!
            - Consider time-expiration session stores like Redis as a backing-service
7. **[Port binding][port-binding]**
    - Export services via port binding
    - **Importance: Medium** Most runtime frameworks will give you this for free.
    - Requirements:
        1. [ ] Can access via a url + port
            - Could be private or public
        1. [ ] One app can become the backing service for another app.
8. **[Concurrency][concurrency]**
    - Scale out via the process model
    - **Importance: Medium** Apps need to be designed with concurrency in mind from the beginning.  You may have diminishing returns in refactoring legacy applications.
    - Requirements:
        1. [ ] Each type of work is assigned to a process type
            - Example:
                - Http requests --> web process
                - Long-running background tasks ---> worker process
        1. [ ] Can span multiple processes
        1. [ ] Rely on system process manager such as systemd to manage output streams, respond to crashed processes, handle user-initiated restarts and shutdowns.  App process never daemonizes or writes PID files.
    - Notes:
        - Internal multiplexing is ok
9. **[Disposability][disposability]**
    - Maximize robustness with fast startup and graceful shutdown
    - **Importance: Medium** Depending on how often you are releasing new code (hopefully many times per day, if you can), and how much you have to scale your app traffic up and down on demand, you probably won’t have to worry about your startup/shutdown speed, but be sure to understand the implications for your app.
    - Requirements:
        1. [ ] Processes can be started or stopped at a moments notice.
        1. [ ] Startup time is minimized.
            - Example: Ahead of Time compilation instead of Just in time compilation in PROD. (JIT is ok in dev)
        1. [ ] Processes shutdown gracefully when they receive a SIGTERM signal from the process manager.
            - Example: Web app stops listening for new requests. 
                - This means that requests are short (<3 seconds MAX).
                - Clients using Long-Polling should automatically reconnect if connection is terminated.
            - Example: Worker process should return current job into the work queue.
                - Assumes all jobs are reentrant.  Uses Transactions or are idempotent.
10. **[Dev/prod parity][dev-prod-parity]**
    - Keep development, staging, and production as similar as possible
    - The twelve-factor developer resists the urge to use different backing services between development and production, even when adapters theoretically abstract away any differences in backing services.
    - **Importance: High** Developers will feel like taking shortcuts if their local environment is working “well enough”. Talk them out of it and take a hard-line stance instead, it’ll pay off long-term.
    - Requirements:
        1. [ ] Keep development, staging, and production as similar as possible
        1. [ ] Make the time gap small: a developer may write code and have it deployed hours or even just minutes later.
        1. [ ] Make the personnel gap small: developers who wrote code are closely involved in deploying it and watching its behavior in production.
        1. [ ] Make the tools gap small: keep development and production as similar as possible.
        1. [ ] Use agnostic adapters for backing services.
            - Example: Use ORM for communicating with database.
        1. [ ] Do not use different backing services in local development and production.
            - Example: Using gunicron instead of mod_wsgi in python.
11. **[Logs][logs]**
    - Treat logs as event streams
    - **Importance: Low** If you are relying on logs as a primary forensic tool, you are probably already missing out on better solutions. Be sure to consolidate your logs for convenience, but beyond that, don’t worry about being a purist here.
    - Requirements:
        1. [ ] One event per line
        1. [ ] App does not manage log storage.
        1. [ ] Each process writes its event stream, unbuffered, to STDOUT.
        1. [ ] Execution Environment captures event stream and routes it to the final log management system.
        1. [ ] At the very least, you should be capturing errors and sending them to an error reporting service
    - Notes:
        These log systems allow for great power and flexibility for introspecting an app’s behavior over time, including:
            - Finding specific events in the past.
            - Large-scale graphing of trends (such as requests per minute).
            - Active alerting according to user-defined heuristics (such as an alert when the quantity of errors per minute exceeds a certain threshold).
12. **[Admin processes][admin-processes]**
    - Run admin/management tasks as one-off processes
    - **Importance: High** Having console access to a production system is a critical administrative and debugging tool, and every major language/framework provides it. No excuses for sloppiness here.
    - Requirements:
        1. [ ] One-Off admin processes are run against a release using the same codebase and config as the regular long-running processes.
        1. [ ] Admin code must ship with the application code to avoid synchronization issues.
        1. [ ] Console access to a production system is a critical administrative and debugging tool
    - Notes:
        - Example: Running database migrations (e.g. manage.py migrate in Django, rake db:migrate in Rails).
        - Example: Running a console (also known as a REPL shell) to run arbitrary code or inspect the app’s models against the live database. Most languages provide a REPL by running the interpreter without any arguments (e.g. python or perl) or in some cases have a separate command (e.g. irb for Ruby, rails console for Rails).
        - Example: Running one-time scripts committed into the app’s repo (e.g. php scripts/fix_bad_records.php).

Resources:
1. [The Twelve Factor App][12factor]
1. [12-Factor Apps in Plain English][12-factor-apps-plain-english]


[12factor]: https://12factor.net/ "The Twelve Factor App"
[codebase]: https://12factor.net/codebase
[dependencies]: https://12factor.net/dependencies
[config]: https://12factor.net/config
[backing-services]: https://12factor.net/backing-services
[build-release-run]: https://12factor.net/build-release-run
[processes]: https://12factor.net/processes
[port-binding]: https://12factor.net/port-binding
[concurrency]: https://12factor.net/concurrency
[disposability]: https://12factor.net/disposability
[dev-prod-parity]: https://12factor.net/dev-prod-parity
[logs]: https://12factor.net/logs
[admin-processes]: https://12factor.net/admin-processes

[12-factor-apps-plain-english]: http://www.clearlytech.com/2014/01/04/12-factor-apps-plain-english/ "12-Factor Apps in Plain English"