;; ------------------------------------------------------
;; community-savings-pool.clar
;; A shared community savings pool where anyone can deposit STX.
;; Only the chosen beneficiary can withdraw from the pool.
;; ------------------------------------------------------

(define-data-var beneficiary principal tx-sender)
(define-data-var total-saved uint u0)

;; Track each contributor's total deposits
(define-map contributions
  { user: principal }
  { amount: uint })

;; -----------------------
;; Errors
;; -----------------------
(define-constant ERR-NOT-BENEFICIARY (err u100))
(define-constant ERR-NOT-ENOUGH (err u101))
(define-constant ERR-ZERO-AMOUNT (err u102))

;; -----------------------
;; Private Helper
;; -----------------------
(define-private (require-beneficiary (caller principal))
  (if (is-eq caller (var-get beneficiary))
      (ok true)
      ERR-NOT-BENEFICIARY))

;; -----------------------
;; Public Functions
;; -----------------------

;; Deposit STX into the community savings pool
(define-public (deposit (amount uint))
  (begin
    (asserts! (> amount u0) ERR-ZERO-AMOUNT)

    ;; Update user's deposit record
    (let ((old (default-to u0 (get amount (map-get? contributions { user: tx-sender })))))
      (map-set contributions { user: tx-sender } { amount: (+ old amount) }))

    ;; Increase total pool balance
    (var-set total-saved (+ (var-get total-saved) amount))

    (ok { event: "deposit", from: tx-sender, pool-balance: (var-get total-saved) })
  )
)

;; Beneficiary withdraws STX from the pool
(define-public (withdraw (amount uint))
  (begin
    ;; Fixed: require-beneficiary now takes tx-sender as argument
    (try! (require-beneficiary tx-sender))
    (asserts! (<= amount (var-get total-saved)) ERR-NOT-ENOUGH)

    ;; Deduct from pool
    (var-set total-saved (- (var-get total-saved) amount))

    ;; Fixed: as-contract now properly wraps the transfer operation
    (try! (as-contract (stx-transfer? amount tx-sender (var-get beneficiary))))

    (ok { event: "withdraw", to: tx-sender, amount: amount })
  )
)

;; Change the beneficiary to a new address
(define-public (set-beneficiary (new-beneficiary principal))
  (begin
    ;; Fixed: require-beneficiary now takes tx-sender as argument
    (try! (require-beneficiary tx-sender))
    (var-set beneficiary new-beneficiary)
    (ok { event: "update-beneficiary", new: new-beneficiary })
  )
)

;; -----------------------
;; Read-Only Views
;; -----------------------

(define-read-only (get-beneficiary)
  (var-get beneficiary))

(define-read-only (get-total-saved)
  (var-get total-saved))

(define-read-only (get-contribution-of (user principal))
  (default-to u0 (get amount (map-get? contributions { user: user }))))
