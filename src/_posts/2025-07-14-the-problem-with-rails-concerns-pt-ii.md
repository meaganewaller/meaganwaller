---
date: 2025-07-14
layout: post
title: The Problem With Rails Concerns Is Not What You Think (Part Two)
summary: Architectural alternatives to mixin sprawl
---

In [Part One](/blog/the-problem-with-rails-concerns), we made the case that Rails Concerns are often a form of architectural procrastination. They make things look clean, but only at a surface level. Underneath, they flatten boundaries, hide ownership, and make your code harder to reason about.

This post is about **doing the harder thing**: designing explicit, intentional structures for your app’s behavior. Not because it’s trendy. Because it’s durable.

Let's look at what that actually means in practice.

## 1. Service Objects: Logic with a Job

Let's take the classic `Billable` concern. It does too many things: totals invoices, creates payments, runs callbacks. We've got workflow logic impersonating a trait.

The better alternative? **Service objects.**

```rb
class InvoicePayer
  def initialize(invoice, payment_gateway: StripeAdapter.new)
    @invoice = invoice
    @payment_gateway = payment_gateway
  end

  def call
    payment_gateway.charge(invoice.total_due)
    invoice.update!(paid_at: Time.current)
    Payment.create!(invoice: invoice, amount: invoice.total_due)
  end
end
```

**Why this is better**:

- Explicit: you know where the logic lives
- Isolated: you can test it in one place, no callbacks required
- Composable: you can inject different gateways for testing, retries, etc.

**And yes, this belongs in `app/services`. It's a service. Own it.**


## 2. Value Objects: Representing Concepts, Not Just Data

If you find yourself with concerns that do things like formatting currency, handling timezones, converting units, that's not model logic. It's a domain concept.

**Wrap it**.

```rb
class Money
  attr_reader :cents, :currency

  def initialize(cents, currency: "USD")
    @cents = cents
    @currency = currency
  end

  def to_s
    "#{currency_symbol}#{formatted_amount}"
  end

  def +(other)
    raise unless currency == other.currency
    Money.new(cents + other.cents, currency: currency)
  end

  private

  def currency_symbol
    { "USD" => "$", "EUR" => "€" }[currency]
  end
end
```

This is how you **give shape to your data**. And suddenly your app stops being a pile of hashes and starts being a world of meaningful things.

## 3. Query Objects: Read Logic Isn't Domain Logic

Many concerns sneak in through scopes:

```rb
module Archivable
  included do
    scope :archived, -> { where.not(archived_at: nil) }
    scope :active, -> { where(archived_at: nil) }
  end
end
```

Here's a better take:

```rb
class ArchivedUsersQuery
  def self.call
    User.where.not(archived_at: nil)
  end
end
```

This:

- Keeps query logic out of your models
- Gives you a place to document _why_ the query exists
- Plays well with composition and test doubles

Your app deserves better than infinite scopes stapled to models.

## 4. Guards, Policies, and Roles

If your `Notifiable` or `RoleAssignable` concerns are full of permission checks or user-type logic, that's a small. Your domain needs a proper **authorization layer**.

```rb
class DocumentPolicy
  def initialize(user, document)
    @user = user
    @document = document
  end

  def can_view?
    document.public? || document.owner == user
  end

  def can_edit?
    document.owner == user
  end
end
```

Now, instead of having mystery methods like `user.can_edit_document?(doc)` defined by some `RoleConcern`, you have:

```rb
DocumentPolicy.new(user, doc).can_edit?
```

Explicit. Discoverable. Testable.

## 5. UI-Only Behavior Belongs in ViewModels

Concerns often contain code that exists **only to support the view**, like:

```rb
def display_name
  "#{first_name} #{last_name}"
end
```

Or worse:

```rb
def status_label
  if active?
    "🟢 Active"
  else
    "🔴 Inactive"
  end
end
```

This logic should not live on your database record. It’s presentation logic. So present it.

```rb
class UserPresenter < SimpleDelegator
  def display_name
    "#{first_name} #{last_name}"
  end

  def status_label
    active? ? "🟢 Active" : "🔴 Inactive"
  end
end
```

This helps you test views more easily, and keeps your domain clean.


## 6. Soft Deletes Without the Side Effects

Soft delete is one of the most abused concerns. Here’s a cleaner approach:

```rb
class SoftDelete
  def initialize(record)
    @record = record
  end

  def call
    record.update!(deleted_at: Time.current)
  end

  def self.restore(record)
    record.update!(deleted_at: nil)
  end
end
```

Let the model store the data. Let another object handle the behavior. Keep it boring. Keep it obvious.


## When a Concern Might Be Fine

Let's not be absolutist. Some concerns _are_ useful:

When the behavior is:

- Truly shared across multiple, unrelated models
- Stateless, or only affects one association
- Rails-specific glue (e.g. validations, `accepts_nested_attributes_for`)
- Tiny, focused, and _very_ well-named

Avoid them when:

- They mutate state
- They define side-effect-y callbacks
- They obscure ownership or domain intent

Basically: if it walks like a service, quacks like a service...it's not a concern.

## Clear Ownership is The Ultimate Goal

Every method should have a home. Every responsibility should have a name. Every behavior should have a reason to live.

Concerns blur those lines.

Better patterns clarify them.

That clarity pays off:

- When debugging
- When refactoring
- When onboarding
- When your app hits its second, third, tenth year.

This isn't about purity. It's about survival.

## Final Thought

It's okay if you feel defensive about your concerns. We’ve all done it. Rails _makes it easy_ to reach for this pattern, and the short-term relief is real.

But if your goal is to grow into seniority, clarity, and code that gets better with age, you owe it to yourself to ask:

> “Would I still be proud of this boundary six months from now?”

If not, don’t reach for `include`. Reach for intent.
