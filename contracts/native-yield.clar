;; Title: BitYield - Bitcoin-Native Yield Optimization Protocol
;;
;; Summary:
;; A comprehensive DeFi aggregator for Stacks blockchain that enables secure yield optimization
;; strategies with full Bitcoin settlement assurances. BitYield connects various Stacks protocols
;; into a unified risk management and portfolio optimization system.
;;
;; Description: 
;; BitYield creates smart vaults that automatically allocate assets across multiple DeFi protocols
;; based on user risk preferences, monitors positions for liquidation risks, and enables portfolio
;; tracking across the Stacks ecosystem. Built with Bitcoin-first security principles and
;; transparency at its core.

;; Error codes
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-INVALID-PROTOCOL (err u101))
(define-constant ERR-INSUFFICIENT-FUNDS (err u102))
(define-constant ERR-INVALID-AMOUNT (err u103))
(define-constant ERR-VAULT-NOT-FOUND (err u104))
(define-constant ERR-PROTOCOL-NOT-REGISTERED (err u105))
(define-constant ERR-UNAUTHORIZED-PROTOCOL (err u106))
(define-constant ERR-INVALID-PARAMETER (err u107))
(define-constant ERR-POSITION-NOT-FOUND (err u108))
(define-constant ERR-LIQUIDATION-THRESHOLD (err u109))
(define-constant ERR-VAULT-FULL (err u110))
(define-constant ERR-SLIPPAGE-TOO-HIGH (err u111))
(define-constant ERR-UNSUPPORTED-TOKEN (err u112))

;; Data maps and variables

;; Track the contract owner
(define-data-var contract-owner principal tx-sender)

;; Protocol registry
(define-map protocols
  { protocol-id: uint }
  {
    name: (string-ascii 64),
    protocol-address: principal,
    is-active: bool,
    trusted: bool,
    supported-tokens: (list 10 (string-ascii 32)),
    protocol-type: (string-ascii 32), ;; lending, dex, farm, etc.
  }
)

;; Vault data structure
(define-map vaults
  { vault-id: uint }
  {
    creator: principal,
    name: (string-ascii 64),
    description: (string-ascii 256),
    strategy: (string-ascii 32),
    target-apy: uint,
    risk-level: uint, ;; 1-10, where 10 is highest risk
    allocation: (list 10 {
      protocol-id: uint,
      percentage: uint,
    }),
    is-active: bool,
    total-assets-ustx: uint,
    creation-height: uint,
  }
)

;; User positions in vaults
(define-map user-vault-positions
  {
    user: principal,
    vault-id: uint,
  }
  {
    amount-ustx: uint,
    entry-height: uint,
    last-rebalance-height: uint,
    earnings-ustx: uint,
    strategy-params: (optional {
      key: (string-ascii 32),
      value: uint,
    }),
  }
)

;; User positions across protocols (portfolio tracker)
(define-map user-protocol-positions
  {
    user: principal,
    protocol-id: uint,
  }
  {
    supplied-assets: (list 5 {
      token: (string-ascii 32),
      amount: uint,
    }),
    borrowed-assets: (list 5 {
      token: (string-ascii 32),
      amount: uint,
    }),
    liquidity-positions: (list 5 {
      pool-id: (string-ascii 32),
      amount: uint,
    }),
    staked-positions: (list 5 {
      asset: (string-ascii 32),
      amount: uint,
    }),
    last-updated-height: uint,
  }
)