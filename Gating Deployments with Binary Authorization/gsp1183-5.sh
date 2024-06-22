gcloud beta container clusters create binauthz \
    --zone us-west1-c  \
    --binauthz-evaluation-mode=PROJECT_SINGLETON_POLICY_ENFORCE

gcloud projects add-iam-policy-binding ${PROJECT_ID} \
        --member="serviceAccount:${PROJECT_NUMBER}@cloudbuild.gserviceaccount.com" \
        --role="roles/container.developer"

gcloud container binauthz policy export

kubectl run hello-server --image gcr.io/google-samples/hello-app:1.0 --port 8080

kubectl get pods

# wait 20 seconds for pod to be ready

kubectl delete pod hello-server

# wait 5 seconds for pod to be deleted

gcloud container binauthz policy export  > policy.yaml

cat > policy.yaml << EOM

globalPolicyEvaluationMode: ENABLE
defaultAdmissionRule:
  evaluationMode: ALWAYS_DENY
  enforcementMode: ENFORCED_BLOCK_AND_AUDIT_LOG
name: projects/$PROJECT_ID/policy

EOM

gcloud container binauthz policy import policy.yaml

kubectl run hello-server --image gcr.io/google-samples/hello-app:1.0 --port 8080

cat > policy.yaml << EOM

globalPolicyEvaluationMode: ENABLE
defaultAdmissionRule:
  evaluationMode: ALWAYS_ALLOW
  enforcementMode: ENFORCED_BLOCK_AND_AUDIT_LOG
name: projects/$PROJECT_ID/policy

EOM

gcloud container binauthz policy import policy.yaml